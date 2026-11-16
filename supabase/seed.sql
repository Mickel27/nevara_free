-- =============================================================================
-- NevaraFresh · Datos iniciales (Seed)
-- Referencia: lib/data/mock_data.dart y docs/modelo.md
--
-- PRERREQUISITO:
--   Antes de ejecutar este script, crea los 6 usuarios en
--   Supabase Dashboard -> Authentication -> Users (con "Auto Confirm User"):
--     1. admin@nevarafresh.com            (Admin · Demo administrador)
--     2. democashier@nevarafresh.com      (Cajero t1 · Demo cajero)
--     3. cashier.sur@nevarafresh.com      (Cajero t2 · Sede Sur)
--     4. cashier.laureles@nevarafresh.com (Cajero t3 · Sede Laureles)
--     5. cashier.centro@nevarafresh.com   (Cajero t4 · Sede Centro)
--     6. cashier.prado@nevarafresh.com    (Cajero t5 · Sede El Prado)
-- =============================================================================

-- 1. Tiendas
INSERT INTO tiendas (id_tienda, nombre_tienda, ciudad) VALUES
  ('t1', 'Sede Norte', 'Cali'),
  ('t2', 'Sede Sur', 'Bogotá'),
  ('t3', 'Sede Laureles', 'Medellín'),
  ('t4', 'Sede Centro', 'Bucaramanga'),
  ('t5', 'Sede El Prado', 'Barranquilla')
ON CONFLICT (id_tienda) DO NOTHING;

-- 2. Categorías
INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
  ('c1', 'Lácteos'),
  ('c2', 'Granos'),
  ('c3', 'Huevos'),
  ('c4', 'Panadería'),
  ('c5', 'Frutas'),
  ('c6', 'Verduras'),
  ('c7', 'Bebidas')
ON CONFLICT (id_categoria) DO NOTHING;

-- 3. Productos (el trigger crea inventario en 0 para cada tienda)
INSERT INTO productos (id_producto, sku, nombre_producto, id_categoria, precio_base, unidad_medida, es_perecedero, activo) VALUES
  ('p1', 'P001', 'Leche entera 1L', 'c1', 4200, 'und.', true, true),
  ('p2', 'P002', 'Arroz blanco 1 kg', 'c2', 5800, 'und.', false, true),
  ('p3', 'P003', 'Huevos AA ×30', 'c3', 18900, 'und.', true, true),
  ('p4', 'P004', 'Pan tajado 500 g', 'c4', 6500, 'und.', true, true),
  ('p5', 'P005', 'Banano ×kg', 'c5', 3200, 'kg', true, true),
  ('p6', 'P006', 'Tomate chonto ×kg', 'c6', 4800, 'kg', true, true),
  ('p7', 'P007', 'Gaseosa 1,5 L', 'c7', 5500, 'und.', false, true),
  ('p8', 'P008', 'Queso campesino 500 g', 'c1', 12900, 'und.', true, true),
  ('p9', 'P009', 'Manzana roja ×kg', 'c5', 7900, 'kg', true, true),
  ('p10', 'P010', 'Agua 600 ml', 'c7', 1800, 'und.', false, true)
ON CONFLICT (id_producto) DO NOTHING;

SELECT setval('seq_producto', 10, true);

-- 4. Inventario inicial por tienda (actualiza las filas creadas por el trigger)
INSERT INTO inventario (id_tienda, id_producto, stock_actual, stock_minimo) VALUES
  -- t1: Sede Norte (Huevos, Tomate y Agua en bajo stock; Pan agotado)
  ('t1', 'p1', 30, 10), ('t1', 'p2', 54, 15), ('t1', 'p3', 8, 10), ('t1', 'p4', 0, 12), ('t1', 'p5', 42, 12),
  ('t1', 'p6', 6, 10),  ('t1', 'p7', 60, 20), ('t1', 'p8', 15, 8), ('t1', 'p9', 22, 10), ('t1', 'p10', 9, 15),
  -- t2: Sede Sur
  ('t2', 'p1', 7, 10),  ('t2', 'p2', 40, 15), ('t2', 'p3', 25, 10), ('t2', 'p4', 18, 12), ('t2', 'p5', 35, 12),
  ('t2', 'p6', 20, 10), ('t2', 'p7', 48, 20), ('t2', 'p8', 12, 8),  ('t2', 'p9', 30, 10), ('t2', 'p10', 40, 15),
  -- t3: Sede Laureles
  ('t3', 'p1', 28, 10), ('t3', 'p2', 36, 15), ('t3', 'p3', 20, 10), ('t3', 'p4', 15, 12), ('t3', 'p5', 30, 12),
  ('t3', 'p6', 18, 10), ('t3', 'p7', 55, 20), ('t3', 'p8', 14, 8),  ('t3', 'p9', 26, 10), ('t3', 'p10', 50, 15),
  -- t4: Sede Centro
  ('t4', 'p1', 33, 10), ('t4', 'p2', 45, 15), ('t4', 'p3', 22, 10), ('t4', 'p4', 20, 12), ('t4', 'p5', 38, 12),
  ('t4', 'p6', 25, 10), ('t4', 'p7', 44, 20), ('t4', 'p8', 10, 8),  ('t4', 'p9', 24, 10), ('t4', 'p10', 35, 15),
  -- t5: Sede El Prado
  ('t5', 'p1', 26, 10), ('t5', 'p2', 38, 15), ('t5', 'p3', 18, 10), ('t5', 'p4', 16, 12), ('t5', 'p5', 40, 12),
  ('t5', 'p6', 22, 10), ('t5', 'p7', 52, 20), ('t5', 'p8', 11, 8),  ('t5', 'p9', 28, 10), ('t5', 'p10', 45, 15)
ON CONFLICT (id_tienda, id_producto) DO UPDATE
SET stock_actual = EXCLUDED.stock_actual,
    stock_minimo = EXCLUDED.stock_minimo;

-- 5. Usuarios vinculados a auth.users por correo (AD-03)
INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, NULL, 'Admin Demo', email, 'administrador', true
FROM auth.users WHERE email = 'admin@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, 't1', 'Cajero Norte (Demo)', email, 'cajero', true
FROM auth.users WHERE email = 'democashier@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, 't2', 'Cajero Sur', email, 'cajero', true
FROM auth.users WHERE email = 'cashier.sur@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, 't3', 'Cajero Laureles', email, 'cajero', true
FROM auth.users WHERE email = 'cashier.laureles@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, 't4', 'Cajero Centro', email, 'cajero', true
FROM auth.users WHERE email = 'cashier.centro@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

INSERT INTO usuarios (id_usuario, id_tienda, nombre_completo, correo, rol, activo)
SELECT id, 't5', 'Cajero El Prado', email, 'cajero', true
FROM auth.users WHERE email = 'cashier.prado@nevarafresh.com'
ON CONFLICT (id_usuario) DO NOTHING;

-- 6. Ventas iniciales (últimos 6 días + hoy V-1036 a V-1042)
DO $$
DECLARE
  v_u2 UUID;
  v_u3 UUID;
  v_u4 UUID;
  v_u5 UUID;
  v_u6 UUID;
  v_id_venta BIGINT;
  v_hoy DATE := CURRENT_DATE;
BEGIN
  SELECT id_usuario INTO v_u2 FROM usuarios WHERE correo = 'democashier@nevarafresh.com';
  SELECT id_usuario INTO v_u3 FROM usuarios WHERE correo = 'cashier.sur@nevarafresh.com';
  SELECT id_usuario INTO v_u4 FROM usuarios WHERE correo = 'cashier.laureles@nevarafresh.com';
  SELECT id_usuario INTO v_u5 FROM usuarios WHERE correo = 'cashier.centro@nevarafresh.com';
  SELECT id_usuario INTO v_u6 FROM usuarios WHERE correo = 'cashier.prado@nevarafresh.com';

  IF v_u2 IS NULL OR v_u3 IS NULL OR v_u4 IS NULL OR v_u5 IS NULL OR v_u6 IS NULL THEN
    RAISE EXCEPTION 'Faltan usuarios en auth.users. Crea primero los 6 usuarios en Authentication -> Users.';
  END IF;

  -- Si ya existen ventas semilla, no duplicar
  IF EXISTS (SELECT 1 FROM ventas WHERE numero_ticket = 'V-1042') THEN
    RETURN;
  END IF;

  -- Hoy: V-1036 a V-1042
  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t3', v_u4, 'V-1036', v_hoy + TIME '10:12', 31800) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p8', 'Queso campesino 500 g', 1, 12900, 12900),
    (v_id_venta, 'p3', 'Huevos AA ×30', 1, 18900, 18900);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t5', v_u6, 'V-1037', v_hoy + TIME '10:30', 21400) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p1', 'Leche entera 1L', 2, 4200, 8400),
    (v_id_venta, 'p4', 'Pan tajado 500 g', 2, 6500, 13000);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t2', v_u3, 'V-1038', v_hoy + TIME '10:47', 15400) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p6', 'Tomate chonto ×kg', 2, 4800, 9600),
    (v_id_venta, 'p2', 'Arroz blanco 1 kg', 1, 5800, 5800);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t4', v_u5, 'V-1039', v_hoy + TIME '11:02', 25400) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p9', 'Manzana roja ×kg', 2, 7900, 15800),
    (v_id_venta, 'p5', 'Banano ×kg', 3, 3200, 9600);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t3', v_u4, 'V-1040', v_hoy + TIME '11:20', 32800) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p7', 'Gaseosa 1,5 L', 4, 5500, 22000),
    (v_id_venta, 'p10', 'Agua 600 ml', 6, 1800, 10800);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t2', v_u3, 'V-1041', v_hoy + TIME '11:35', 31800) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p3', 'Huevos AA ×30', 1, 18900, 18900),
    (v_id_venta, 'p8', 'Queso campesino 500 g', 1, 12900, 12900);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t1', v_u2, 'V-1042', v_hoy + TIME '11:41', 19100) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p1', 'Leche entera 1L', 3, 4200, 12600),
    (v_id_venta, 'p4', 'Pan tajado 500 g', 1, 6500, 6500);

  -- Días anteriores (para el gráfico de la semana en el Dashboard)
  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t1', v_u2, 'V-1034', (v_hoy - 1) + TIME '10:15', 16800) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p2', 'Arroz blanco 1 kg', 1, 5800, 5800),
    (v_id_venta, 'p7', 'Gaseosa 1,5 L', 2, 5500, 11000);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t4', v_u5, 'V-1035', (v_hoy - 1) + TIME '16:40', 19000) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p1', 'Leche entera 1L', 3, 4200, 12600),
    (v_id_venta, 'p5', 'Banano ×kg', 2, 3200, 6400);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t2', v_u3, 'V-1032', (v_hoy - 2) + TIME '10:15', 22600) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p2', 'Arroz blanco 1 kg', 2, 5800, 11600),
    (v_id_venta, 'p7', 'Gaseosa 1,5 L', 2, 5500, 11000);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t5', v_u6, 'V-1033', (v_hoy - 3) + TIME '16:40', 25400) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p1', 'Leche entera 1L', 3, 4200, 12600),
    (v_id_venta, 'p5', 'Banano ×kg', 4, 3200, 12800);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t3', v_u4, 'V-1030', (v_hoy - 4) + TIME '10:15', 34200) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p2', 'Arroz blanco 1 kg', 4, 5800, 23200),
    (v_id_venta, 'p7', 'Gaseosa 1,5 L', 2, 5500, 11000);

  INSERT INTO ventas (id_tienda, id_usuario, numero_ticket, fecha_hora, total_venta)
  VALUES ('t2', v_u3, 'V-1031', (v_hoy - 5) + TIME '16:40', 31800) RETURNING id_venta INTO v_id_venta;
  INSERT INTO detalle_ventas (id_venta, id_producto, nombre_producto, cantidad, precio_unitario, subtotal) VALUES
    (v_id_venta, 'p1', 'Leche entera 1L', 3, 4200, 12600),
    (v_id_venta, 'p5', 'Banano ×kg', 6, 3200, 19200);
END $$;
