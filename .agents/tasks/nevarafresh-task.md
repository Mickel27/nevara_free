# [TASK-001] Lista de Tareas Verificables · Prototipo NevaraFresh

## Metadatos
- ID: TASK-001
- Plan asociado: [PLAN-001](../plans/nevarafresh-plan.md)
- Specs asociadas: [F-01 a F-11](../../docs/specs/README.md)
- Fecha: 2026-11-07
- Estado general: IN_PROGRESS (falta el video y el pull request de la Tarea 17)
- Rama de trabajo: `prototipo` (creada desde `especificaciones`)

## Como usar esta lista
1. Hacer las tareas en orden; las marcadas como paralelizables pueden repartirse.
2. Una tarea se marca `- [x]` solo cuando pasa su verificacion.
3. Un commit por tarea: `git commit -m "Tarea N: <titulo>"`.
4. Reglas en todas las tareas: `Scaffold` solo en `screens/`; Pages sin `Scaffold`; datos por constructor y eventos por callbacks; constructores `const`; sin `print`; solo `services/` conoce los datos.

## Resumen de Progreso
- [x] Tarea 0: Preparar el proyecto
- [x] Tarea 1: Modelos
- [x] Tarea 2: Datos simulados
- [x] Tarea 3: Servicios en memoria y sus pruebas
- [x] Tarea 4: Widgets base (paralelizable)
- [x] Tarea 5: Widgets de lista (paralelizable)
- [x] Tarea 6: Widgets de navegacion (paralelizable)
- [x] Tarea 7: Widgets de retroalimentacion (paralelizable)
- [x] Tarea 8: Inicio de sesion (F-01)
- [x] Tarea 9: Punto de venta (F-02)
- [x] Tarea 10: Stock de mi tienda y Mis ventas (F-03, F-11)
- [x] Tarea 11: Dashboard (F-04)
- [x] Tarea 12: Inventario por tienda (F-05)
- [x] Tarea 13: Reponer existencias (F-06)
- [x] Tarea 14: Agregar y editar producto (F-07, F-08)
- [x] Tarea 15: Eliminar producto (F-09)
- [x] Tarea 16: Historial de ventas (F-10)
- [ ] Tarea 17: Cierre, calidad y entrega

---

## Desglose Detallado

### - [x] Tarea 0: Preparar el proyecto
- Dependencias previas: Ninguna
- Archivos involucrados: `lib/` completo, `test/widget_test.dart`, `lib/main.dart`
- Acciones:
  - [x] 1. `git checkout especificaciones` y `git checkout -b prototipo`.
  - [x] 2. Revisar el `lib/` actual contra el plan: anotar que widgets coinciden con la galeria y cumplen las reglas.
  - [x] 3. Mover lo reutilizable a su carpeta del plan con su nombre del plan; borrar lo que no aparece en el plan.
  - [x] 4. Crear las carpetas `models/`, `data/`, `services/`, `widgets/`, `pages/`, `screens/`, `routes/`.
  - [x] 5. Dejar `main.dart` con un `MaterialApp` minimo y borrar o vaciar `test/widget_test.dart` (prueba del contador que ya no aplica).
- Verificacion:
  - [x] `flutter analyze` sin errores.
  - [x] `flutter run -d chrome` abre una pantalla en blanco sin fallar.

---

### - [x] Tarea 1: Modelos
- Dependencias previas: Tarea 0
- Archivos involucrados: `lib/models/tienda.dart`, `usuario.dart`, `categoria.dart`, `producto.dart`, `inventario.dart`, `venta.dart`, `detalle_venta.dart`, `reposicion.dart`, `item_carrito.dart` (crear)
- Acciones:
  - [x] 1. Crear cada clase con campos `final` y constructor `const`, segun la tabla del plan.
  - [x] 2. Enums `Rol` y `EstadoStock`.
  - [x] 3. Getters: `Inventario.estado`, `Venta.total`, `Venta.unidades`, `DetalleVenta.subtotal`, `ItemCarrito.subtotal`, `Usuario.iniciales`.
  - [x] 4. `copyWith` en `Producto` e `Inventario`.
  - [x] 5. Pruebas: `test/models/inventario_test.dart` (0 = agotado, 8 con minimo 10 = bajo, 30 con minimo 10 = disponible) y `test/models/item_carrito_test.dart` (Leche x3 + Arroz x2 + Banano x1 = $27.400).
- Verificacion:
  - [x] `flutter test test/models` en verde.
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 2: Datos simulados
- Dependencias previas: Tarea 1
- Archivos involucrados: `lib/data/mock_data.dart` (crear)
- Acciones:
  - [x] 1. Tiendas, usuarios, categorias y productos P001 a P010 segun el plan y el Figma.
  - [x] 2. Inventario de cada producto en cada tienda; Sede Norte con los valores del Figma.
  - [x] 3. Ventas V-1036 a V-1042 de hoy, con sus detalles.
  - [x] 4. Revisar que cada dato tenga su campo en `docs/modelo.md`.
- Verificacion:
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 3: Servicios en memoria y sus pruebas
- Dependencias previas: Tarea 2
- Archivos involucrados: `lib/services/auth_service.dart`, `catalogo_service.dart`, `inventario_service.dart`, `venta_service.dart` (crear); `test/services/*_test.dart` (crear)
- Acciones:
  - [x] 1. Cada servicio copia sus listas de `mock_data.dart` al crearse y expone las firmas del plan como `Future`, con una espera corta simulada.
  - [x] 2. `AuthService`: login por correo y contrasena, demo por rol, usuario actual y cierre de sesion; error si no coincide o el usuario esta inactivo.
  - [x] 3. `CatalogoService`: agregar (sku unico, crea inventario en 0 en cada tienda), editar, eliminar como inactivo.
  - [x] 4. `InventarioService`: por tienda, todos, reponer (solo esa tienda + registro de reposicion), cambiar minimo.
  - [x] 5. `VentaService`: registrar (valida existencias, numero siguiente, descuenta todo o nada), listar con filtros, ventas de un usuario.
  - [x] 6. Pruebas de la tabla del plan: F-01 CA-4, F-02 CA-4 y CA-6, F-06 CA-1 y CA-2, F-07 CA-3, F-09 CA-2.
- Verificacion:
  - [x] `flutter test test/services` en verde.
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 4: Widgets base (paralelizable con 5, 6 y 7)
- Dependencias previas: Tarea 1
- Archivos involucrados: `lib/widgets/logo.dart`, `boton_nf.dart`, `campo_texto.dart`, `buscador.dart`, `selector.dart`, `etiqueta_estado.dart` (crear)
- Acciones:
  - [x] 1. Crear cada widget con los parametros del plan y el estilo de la galeria del Figma.
  - [x] 2. `BotonNF` con variantes principal, secundario y peligro; deshabilitado si `onPressed` es null.
  - [x] 3. `EtiquetaEstado` con los tres colores de la galeria.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: mostrar los widgets en una pantalla temporal y compararlos con la galeria.

---

### - [x] Tarea 5: Widgets de lista (paralelizable)
- Dependencias previas: Tareas 1 y 4
- Archivos involucrados: `lib/widgets/tarjeta_producto.dart`, `item_carrito_tile.dart`, `tarjeta_estadistica.dart`, `fila_inventario.dart`, `fila_venta.dart` (crear); `test/widgets/tarjeta_producto_test.dart` (crear)
- Acciones:
  - [x] 1. Crear cada widget segun el plan.
  - [x] 2. `TarjetaProducto`: si esta agotado, muestra "Agotado" y "Sin stock" deshabilitado; si esta bajo, "Stock: N · bajo".
  - [x] 3. `FilaInventario`: sin callbacks no muestra acciones.
  - [x] 4. Widget test de F-02 CA-5 (agotado no se puede agregar).
- Verificacion:
  - [x] `flutter test test/widgets` en verde.
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 6: Widgets de navegacion (paralelizable)
- Dependencias previas: Tareas 1 y 4
- Archivos involucrados: `lib/widgets/item_menu.dart`, `menu_lateral.dart`, `barra_superior.dart` (crear)
- Acciones:
  - [x] 1. `ItemMenu` activo e inactivo.
  - [x] 2. `MenuLateral` recibe la lista de items, el seleccionado, el usuario (iniciales, nombre, rol y tienda) y el callback de cerrar sesion.
  - [x] 3. `BarraSuperior` con titulo, subtitulo, selector de tienda opcional y fecha.
- Verificacion:
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 7: Widgets de retroalimentacion (paralelizable)
- Dependencias previas: Tarea 4
- Archivos involucrados: `lib/widgets/alerta_bajo_stock.dart`, `notificacion.dart`, `modal_nf.dart`, `grafico_ventas_semana.dart`, `paginador.dart`, `estado_vacio.dart`, `estado_error.dart`, `reponer_form.dart`, `producto_form.dart` (crear)
- Acciones:
  - [x] 1. `ModalNF` con titulo, descripcion, contenido y Cancelar / Confirmar.
  - [x] 2. `mostrarNotificacion` con el estilo del Figma.
  - [x] 3. `GraficoVentasSemana` con barras de `Container` y la de hoy resaltada.
  - [x] 4. `ReponerForm` (Stateful por su controller): muestra existencias actuales y como quedarian; Registrar deshabilitado con 0 o vacio; devuelve las unidades con `pop`.
  - [x] 5. `ProductoForm` (Stateful por sus controllers): campos obligatorios, sku unico, precio > 0, minimo al editar; devuelve el resultado con `pop`.
- Verificacion:
  - [x] `flutter analyze` sin problemas.

---

### - [x] Tarea 8: Inicio de sesion (F-01)
- Dependencias previas: Tareas 3, 4 y 6
- Archivos involucrados: `lib/pages/login_page.dart`, `lib/screens/login_screen.dart`, `lib/routes/app_routes.dart`, `lib/main.dart`; temporales `lib/screens/admin_screen.dart` y `cajero_screen.dart` con un texto
- Acciones:
  - [x] 1. `LoginPage` con correo, contrasena, Iniciar sesion y Demo administrador / Demo cajero; muestra `cargando` y `error`.
  - [x] 2. `LoginScreen` con el panel verde de la izquierda del Figma; llama a `AuthService` y navega con `pushNamedAndRemoveUntil` segun el rol.
  - [x] 3. Rutas `/`, `/admin`, `/cajero` y `main.dart` con el tema de la marca.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-01 CA-1 a CA-5 (admin entra a /admin, cajero a /cajero, demo sin credenciales, error con contrasena equivocada, cerrar sesion y "atras" no vuelve).

---

### - [x] Tarea 9: Punto de venta (F-02)
- Dependencias previas: Tareas 5, 6, 7 y 8
- Archivos involucrados: `lib/pages/punto_venta_page.dart` (crear), `lib/screens/cajero_screen.dart` (completar)
- Acciones:
  - [x] 1. `CajeroScreen` Stateful con `MenuLateral` (Punto de venta, Stock de mi tienda, Mis ventas), `BarraSuperior` e `IndexedStack`; carga productos e inventario de su tienda en `initState`.
  - [x] 2. `PuntoVentaPage` con buscador, categorias, grilla de `TarjetaProducto` y panel de venta actual con `ItemCarritoTile`, totales, Confirmar y Cancelar.
  - [x] 3. En la Screen: agregar al carrito sin superar existencias, sumar y restar (en 0 sale), cancelar, confirmar con `ModalNF`, registrar con `VentaService`, vaciar carrito, recargar inventario y `mostrarNotificacion`.
  - [x] 4. Estados: cargando, carrito vacio ("El carrito esta vacio" y Confirmar deshabilitado), error al registrar (se conserva el carrito).
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-02 CA-1 a CA-9 (con Leche 30 → 27 tras vender 3).

---

### - [x] Tarea 10: Stock de mi tienda y Mis ventas (F-03, F-11)
- Dependencias previas: Tarea 9
- Archivos involucrados: `lib/pages/stock_tienda_page.dart`, `lib/pages/mis_ventas_page.dart` (crear), `lib/screens/cajero_screen.dart` (modificar)
- Acciones:
  - [x] 1. `StockTiendaPage`: `FilaInventario` sin acciones, buscador y categoria, estados vacio y error.
  - [x] 2. `MisVentasPage`: ventas de hoy del cajero con `FilaVenta`, conteo y total, busqueda por numero.
  - [x] 3. La Screen recarga "Mis ventas" despues de cada venta.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-03 CA-1 a CA-5 y F-11 CA-1 a CA-4.

---

### - [x] Tarea 11: Dashboard (F-04)
- Dependencias previas: Tareas 5, 6, 7 y 8
- Archivos involucrados: `lib/pages/dashboard_page.dart` (crear), `lib/screens/admin_screen.dart` (completar)
- Acciones:
  - [x] 1. `AdminScreen` Stateful con `MenuLateral` (Dashboard, Inventario, Historial de ventas), `BarraSuperior` con selector de tienda e `IndexedStack`; carga todo en `initState`.
  - [x] 2. `DashboardPage` con 4 `TarjetaEstadistica`, `GraficoVentasSemana`, `AlertaBajoStock` y la lista de poco inventario; "Ver inventario" cambia el indice a Inventario.
  - [x] 3. Calcular en `build` los indicadores segun la tienda seleccionada.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-04 CA-1 a CA-6.

---

### - [x] Tarea 12: Inventario por tienda (F-05)
- Dependencias previas: Tarea 11
- Archivos involucrados: `lib/pages/inventario_page.dart` (crear), `lib/screens/admin_screen.dart` (modificar)
- Acciones:
  - [x] 1. `InventarioPage` con buscador, categoria, tienda, Reponer existencias, Agregar producto, `FilaInventario` y `Paginador` de 10 en 10.
  - [x] 2. La Screen filtra por tienda, categoria y busqueda y calcula la pagina.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-05 CA-1 a CA-6.

---

### - [x] Tarea 13: Reponer existencias (F-06)
- Dependencias previas: Tarea 12
- Archivos involucrados: `lib/screens/admin_screen.dart` (modificar)
- Acciones:
  - [x] 1. `onReponer` abre `ModalNF` con `ReponerForm`; con el resultado llama `InventarioService.reponer`, recarga y muestra "Stock actualizado".
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-06 CA-1 a CA-5 (Huevos 8 + 24 = 32 y pasa a Disponible; Sede Sur no cambia).

---

### - [x] Tarea 14: Agregar y editar producto (F-07, F-08)
- Dependencias previas: Tarea 12
- Archivos involucrados: `lib/screens/admin_screen.dart` (modificar)
- Acciones:
  - [x] 1. `onAgregar` abre `ProductoForm` vacio; con el resultado llama `CatalogoService.agregar`, recarga y notifica "Producto agregado".
  - [x] 2. `onEditar` abre `ProductoForm` con los datos y el minimo de la tienda; llama `editar` y `cambiarMinimo`, recarga y notifica "Producto actualizado".
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-07 CA-1 a CA-5 y F-08 CA-1 a CA-4.

---

### - [x] Tarea 15: Eliminar producto (F-09)
- Dependencias previas: Tarea 12
- Archivos involucrados: `lib/screens/admin_screen.dart` (modificar)
- Acciones:
  - [x] 1. `onEliminar` abre `ModalNF` de confirmacion; llama `CatalogoService.eliminar`, recarga y notifica "Producto eliminado".
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-09 CA-1 a CA-4 (la venta con el producto sigue en el historial).

---

### - [x] Tarea 16: Historial de ventas (F-10)
- Dependencias previas: Tarea 11
- Archivos involucrados: `lib/pages/historial_ventas_page.dart` (crear), `lib/screens/admin_screen.dart` (modificar)
- Acciones:
  - [x] 1. `HistorialVentasPage` con buscador (numero o cajero), tienda, fecha, los tres totales y `FilaVenta`.
  - [x] 2. La Screen filtra y calcula ventas, total y promedio.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] Manual: F-10 CA-1 a CA-5.

---

### - [ ] Tarea 17: Cierre, calidad y entrega
- Dependencias previas: Tareas 0 a 16
- Archivos involucrados: `docs/specs/README.md`, specs F-01 a F-11 (modificar estado)
- Acciones:
  - [x] 1. `dart format lib test`.
  - [x] 2. Recorrido completo de punta a punta: login cajero → vender → cerrar sesion → login admin → ver el stock descontado → reponer → agregar, editar y eliminar producto → historial.
  - [ ] 3. Pasar las specs implementadas a estado `implementada` y actualizar el avance del indice.
  - [ ] 4. Grabar el video de maximo 2 minutos con ese recorrido.
  - [ ] 5. Pull request de `prototipo` a `main` y permiso de lectura para el profesor.
- Verificacion:
  - [x] `flutter analyze` sin problemas.
  - [x] `flutter test` completo en verde.
