-- =============================================================================
-- NevaraFresh · Esquema de Base de Datos (Postgres / Supabase)
-- Referencia: docs/modelo.md y docs/architectural_spine.md
-- RLS: Desactivado en esta versión (AD-04 controlado en la app).
-- =============================================================================

-- Secuencias
CREATE SEQUENCE IF NOT EXISTS seq_producto START WITH 11;
CREATE SEQUENCE IF NOT EXISTS seq_numero_ticket START WITH 1043;

-- -----------------------------------------------------------------------------
-- 1. Tablas
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tiendas (
  id_tienda TEXT PRIMARY KEY,
  nombre_tienda TEXT NOT NULL,
  ciudad TEXT NOT NULL,
  direccion TEXT,
  telefono TEXT,
  estado TEXT NOT NULL DEFAULT 'activa'
);

CREATE TABLE IF NOT EXISTS usuarios (
  id_usuario UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  id_tienda TEXT REFERENCES tiendas(id_tienda),
  nombre_completo TEXT NOT NULL,
  correo TEXT UNIQUE NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('administrador', 'cajero')),
  activo BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS categorias (
  id_categoria TEXT PRIMARY KEY,
  nombre_categoria TEXT NOT NULL,
  descripcion TEXT
);

CREATE TABLE IF NOT EXISTS productos (
  id_producto TEXT PRIMARY KEY DEFAULT ('p' || nextval('seq_producto')::TEXT),
  id_categoria TEXT NOT NULL REFERENCES categorias(id_categoria),
  sku TEXT UNIQUE NOT NULL,
  nombre_producto TEXT NOT NULL,
  descripcion TEXT,
  precio_base INTEGER NOT NULL CHECK (precio_base > 0),
  unidad_medida TEXT NOT NULL,
  es_perecedero BOOLEAN NOT NULL DEFAULT false,
  activo BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS inventario (
  id_inventario BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_tienda TEXT NOT NULL REFERENCES tiendas(id_tienda),
  id_producto TEXT NOT NULL REFERENCES productos(id_producto),
  stock_actual INTEGER NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
  stock_minimo INTEGER NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
  stock_maximo INTEGER,
  ultima_actualizacion TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (id_tienda, id_producto)
);

CREATE TABLE IF NOT EXISTS ventas (
  id_venta BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_tienda TEXT NOT NULL REFERENCES tiendas(id_tienda),
  id_usuario UUID NOT NULL REFERENCES usuarios(id_usuario),
  numero_ticket TEXT UNIQUE NOT NULL,
  fecha_hora TIMESTAMPTZ NOT NULL DEFAULT now(),
  total_venta INTEGER NOT NULL CHECK (total_venta >= 0),
  metodo_pago TEXT
);

CREATE TABLE IF NOT EXISTS detalle_ventas (
  id_detalle_venta BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_venta BIGINT NOT NULL REFERENCES ventas(id_venta) ON DELETE CASCADE,
  id_producto TEXT NOT NULL REFERENCES productos(id_producto),
  nombre_producto TEXT NOT NULL,
  cantidad INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario INTEGER NOT NULL CHECK (precio_unitario >= 0),
  subtotal INTEGER NOT NULL CHECK (subtotal >= 0),
  descuento INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS reposiciones (
  id_reposicion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_tienda TEXT NOT NULL REFERENCES tiendas(id_tienda),
  id_producto TEXT NOT NULL REFERENCES productos(id_producto),
  id_usuario UUID NOT NULL REFERENCES usuarios(id_usuario),
  fecha_solicitud TIMESTAMPTZ NOT NULL DEFAULT now(),
  fecha_entrega TIMESTAMPTZ NOT NULL DEFAULT now(),
  cantidad_solicitada INTEGER NOT NULL CHECK (cantidad_solicitada > 0),
  cantidad_recibida INTEGER NOT NULL CHECK (cantidad_recibida > 0),
  estado TEXT NOT NULL DEFAULT 'recibida'
);

-- Asegurar RLS desactivado en todas las tablas (primera versión)
ALTER TABLE tiendas DISABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE categorias DISABLE ROW LEVEL SECURITY;
ALTER TABLE productos DISABLE ROW LEVEL SECURITY;
ALTER TABLE inventario DISABLE ROW LEVEL SECURITY;
ALTER TABLE ventas DISABLE ROW LEVEL SECURITY;
ALTER TABLE detalle_ventas DISABLE ROW LEVEL SECURITY;
ALTER TABLE reposiciones DISABLE ROW LEVEL SECURITY;

-- -----------------------------------------------------------------------------
-- 2. Trigger: al crear un producto, crear inventario en 0 en cada tienda (F-07)
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_crear_inventario_producto()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO inventario (id_tienda, id_producto, stock_actual, stock_minimo)
  SELECT id_tienda, NEW.id_producto, 0, 0
  FROM tiendas
  ON CONFLICT (id_tienda, id_producto) DO NOTHING;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_crear_inventario_producto ON productos;
CREATE TRIGGER trg_crear_inventario_producto
AFTER INSERT ON productos
FOR EACH ROW
EXECUTE FUNCTION fn_crear_inventario_producto();

-- -----------------------------------------------------------------------------
-- 3. RPC: Registrar venta atómica (todo o nada · AD-06, F-02)
-- p_items formato: [{"id_producto": "p1", "cantidad": 3}, ...]
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION registrar_venta(
  p_id_tienda TEXT,
  p_id_usuario UUID,
  p_items JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
  v_item JSONB;
  v_id_producto TEXT;
  v_cantidad INTEGER;
  v_nombre_producto TEXT;
  v_precio INTEGER;
  v_activo BOOLEAN;
  v_stock_actual INTEGER;
  v_total INTEGER := 0;
  v_numero_ticket TEXT;
  v_id_venta BIGINT;
  v_fecha_hora TIMESTAMPTZ := now();
  v_detalles JSONB := '[]'::JSONB;
BEGIN
  IF p_items IS NULL OR jsonb_typeof(p_items) <> 'array' OR jsonb_array_length(p_items) = 0 THEN
    RAISE EXCEPTION 'La venta no tiene productos';
  END IF;

  -- 1. Validar y descontar en orden determinístico para evitar deadlocks
  FOR v_item IN
    SELECT elem
    FROM jsonb_array_elements(p_items) AS elem
    ORDER BY elem->>'id_producto'
  LOOP
    v_id_producto := v_item->>'id_producto';
    v_cantidad := (v_item->>'cantidad')::INTEGER;

    IF v_cantidad IS NULL OR v_cantidad <= 0 THEN
      RAISE EXCEPTION 'Cantidad inválida para el producto %', v_id_producto;
    END IF;

    SELECT p.nombre_producto, p.precio_base, p.activo
      INTO v_nombre_producto, v_precio, v_activo
    FROM productos p
    WHERE p.id_producto = v_id_producto;

    IF NOT FOUND OR NOT v_activo THEN
      RAISE EXCEPTION 'Producto no disponible (%)', v_id_producto;
    END IF;

    SELECT i.stock_actual
      INTO v_stock_actual
    FROM inventario i
    WHERE i.id_tienda = p_id_tienda
      AND i.id_producto = v_id_producto
    FOR UPDATE;

    IF NOT FOUND OR v_stock_actual < v_cantidad THEN
      RAISE EXCEPTION 'No hay existencias suficientes de %', v_nombre_producto;
    END IF;

    UPDATE inventario
    SET stock_actual = stock_actual - v_cantidad,
        ultima_actualizacion = v_fecha_hora
    WHERE id_tienda = p_id_tienda
      AND id_producto = v_id_producto;

    v_total := v_total + (v_cantidad * v_precio);

    v_detalles := v_detalles || jsonb_build_object(
      'id_producto', v_id_producto,
      'nombre_producto', v_nombre_producto,
      'cantidad', v_cantidad,
      'precio_unitario', v_precio,
      'subtotal', v_cantidad * v_precio
    );
  END LOOP;

  -- 2. Crear cabecera de venta y detalles
  v_numero_ticket := 'V-' || nextval('seq_numero_ticket')::TEXT;

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES (p_id_tienda, p_id_usuario, v_numero_ticket, v_fecha_hora, v_total)
  RETURNING id_venta INTO v_id_venta;

  INSERT INTO detalle_ventas (
    id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal
  )
  SELECT
    v_id_venta,
    d->>'id_producto',
    d->>'nombre_producto',
    (d->>'cantidad')::INTEGER,
    (d->>'precio_unitario')::INTEGER,
    (d->>'subtotal')::INTEGER
  FROM jsonb_array_elements(v_detalles) AS d;

  RETURN jsonb_build_object(
    'id_venta', v_id_venta,
    'numero_ticket', v_numero_ticket,
    'id_tienda', p_id_tienda,
    'id_usuario', p_id_usuario,
    'fecha_hora', v_fecha_hora,
    'total_venta', v_total,
    'detalles', v_detalles
  );
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. RPC: Reponer existencias atómicamente (F-06)
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION reponer_inventario(
  p_id_tienda TEXT,
  p_id_producto TEXT,
  p_id_usuario UUID,
  p_unidades INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
  v_stock_actual INTEGER;
  v_stock_minimo INTEGER;
  v_ahora TIMESTAMPTZ := now();
BEGIN
  IF p_unidades IS NULL OR p_unidades <= 0 THEN
    RAISE EXCEPTION 'Las unidades deben ser mayores que 0';
  END IF;

  UPDATE inventario
  SET stock_actual = stock_actual + p_unidades,
      ultima_actualizacion = v_ahora
  WHERE id_tienda = p_id_tienda
    AND id_producto = p_id_producto
  RETURNING stock_actual, stock_minimo
    INTO v_stock_actual, v_stock_minimo;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No existe ese producto en la tienda';
  END IF;

  INSERT INTO reposiciones (
    id_tienda, id_producto, id_usuario,
    fecha_solicitud, fecha_entrega,
    cantidad_solicitada, cantidad_recibida, estado
  )
  VALUES (
    p_id_tienda, p_id_producto, p_id_usuario,
    v_ahora, v_ahora,
    p_unidades, p_unidades, 'recibida'
  );

  RETURN jsonb_build_object(
    'id_tienda', p_id_tienda,
    'id_producto', p_id_producto,
    'stock_actual', v_stock_actual,
    'stock_minimo', v_stock_minimo
  );
END;
$$;
