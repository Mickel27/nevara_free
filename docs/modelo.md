---
documento: modelo
proyecto: NevaraFresh
version: 0.1.0
fecha: 2026-11-07
estado: borrador
basado_en: [MER del equipo]
---

# Modelo de datos · NevaraFresh

Versión en texto del MER del equipo. Es la referencia para los datos simulados del prototipo y para la base de datos.

## Entidades

- **Tienda**: id_tienda, nombre_tienda, ciudad, direccion, telefono, estado.
- **Usuario**: id_usuario, id_tienda, nombre_completo, correo (único), rol (`administrador` o `cajero`), activo.
- **Categoria**: id_categoria, nombre_categoria, descripcion.
- **Producto**: id_producto, id_categoria, sku (único, por ejemplo `P001`), nombre_producto, descripcion, precio_base, unidad_medida, es_perecedero, activo.
- **Inventario**: id_inventario, id_tienda, id_producto, stock_actual, stock_minimo, stock_maximo, ultima_actualizacion. La pareja (id_tienda, id_producto) es única: un producto tiene una sola fila de existencias por tienda.
- **Venta**: id_venta, id_tienda, id_usuario, numero_ticket (por ejemplo `V-1043`), fecha_hora, total_venta, metodo_pago.
- **Detalle_venta**: id_detalle_venta, id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento.
- **Reposicion**: id_reposicion, id_tienda, id_producto, id_usuario, fecha_solicitud, fecha_entrega, cantidad_solicitada, cantidad_recibida, estado.

## Relaciones

- Una tienda tiene muchos usuarios, muchas filas de inventario, muchas ventas y muchas reposiciones.
- Una categoría tiene muchos productos.
- Un producto tiene una fila de inventario por tienda y aparece en muchos detalles de venta y reposiciones.
- Una venta tiene uno o más detalles de venta y la registra un usuario.

## Ajustes para la primera versión

- **Usuario**: `id_usuario` es el identificador de la cuenta con que el usuario inicia sesión, para que la persona tenga una sola identidad.
- **Reposicion**: como la reposición es de un solo paso, cada fila se guarda con `fecha_solicitud` = `fecha_entrega`, `cantidad_solicitada` = `cantidad_recibida` y `estado` = `recibida`.
- **Venta** y **Detalle_venta**: `metodo_pago` y `descuento` quedan vacíos; no se usan en la primera versión.
- **Inventario**: `stock_maximo` no se usa en la primera versión.
- **Producto**: se agrega `activo`. Eliminar un producto lo marca como inactivo en vez de borrarlo, para que las ventas que ya lo tienen sigan en el historial.
- **Estado de un producto en una tienda**: Agotado si `stock_actual` = 0; Bajo stock si `stock_actual` ≤ `stock_minimo`; Disponible en otro caso.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión, a partir del MER.
