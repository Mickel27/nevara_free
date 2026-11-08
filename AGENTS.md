# NevaraFresh · Guía para agentes

Punto de entrada para los agentes de IA que trabajan en este repositorio. Léelo antes de cambiar código o documentos.

## Qué es la app

App de inventario y punto de venta para las tiendas de la cadena de supermercados NevaraFresh. Tiene dos roles:

- **Cajero**: registra las ventas de su tienda y consulta las existencias y sus ventas.
- **Administrador**: ve el resumen de la cadena, gestiona el inventario por tienda, repone existencias, mantiene el catálogo de productos y revisa el historial de ventas.

Corre en el navegador de un computador. Frontend en Flutter y backend en Supabase (Auth y base de datos).

## Estructura de `lib/`

```
lib/
├── main.dart        Punto de entrada y MaterialApp
├── routes/          Nombres de ruta y mapa de rutas
├── models/          Clases de datos (Producto, Inventario, Venta...)
├── data/            Datos simulados, coherentes con docs/modelo.md
├── services/        Única capa que habla con Supabase
├── screens/         Pantallas completas: Scaffold, menú lateral y estado
├── pages/           Contenido de cada pantalla, sin Scaffold
└── widgets/         Componentes reutilizables de la galería del Figma
```

## Reglas de código

- Una Screen provee el Scaffold y guarda el estado de su parte de la app; una Page nunca lleva Scaffold propio.
- Las Pages y los widgets reciben datos por constructor y avisan los cambios con callbacks. Ninguna Page guarda por su cuenta los datos de la app.
- Cada componente de la galería del Figma se construye una sola vez en `widgets/` y se reutiliza.
- Solo `services/` llama a Supabase (ver `docs/architectural_spine.md`).
- No se escribe código sin una spec en `docs/specs/` que lo respalde.

## Documentos

La carpeta `docs/` tiene la especificación del proyecto, en este orden:

- `docs/prd.md`: el problema, los usuarios, los objetivos y el alcance.
- `docs/requisitos.md`: requisitos funcionales y no funcionales, ligados a los objetivos.
- `docs/modelo.md`: el modelo de datos del equipo.
- `docs/architectural_spine.md`: stack, servicios e invariantes de arquitectura.
- `docs/specs/`: una spec funcional por funcionalidad, el índice (`README.md`) y el reporte de calidad (`reporte.md`).
- `docs/figma/`: las pantallas y la galería de componentes del diseño.

## Skills

En `.agents/skills/` están las skills del curso para generar y revisar los documentos: `sdd-prd`, `sdd-requisitos`, `sdd-arquitectura`, `sdd-specs` y `sdd-critica`.
