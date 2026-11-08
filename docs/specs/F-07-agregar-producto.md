---
id: F-07
titulo: Agregar producto
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-18]
depende_de: [F-05]
---

# F-07 · Agregar producto

## Objetivo

El administrador agrega un producto nuevo al catálogo de la cadena.

## Flujo principal

1. En el inventario, el administrador elige "Agregar producto".
2. El sistema pide código, nombre, categoría, precio y unidad de medida, y si es perecedero.
3. El administrador llena los datos y elige "Guardar".
4. El sistema agrega el producto al catálogo, con 0 existencias en cada tienda, y muestra "Producto agregado".
5. El producto aparece en el inventario de cada tienda y en el catálogo de venta como "Agotado".

## Flujos alternos

- **A1 · Cancelar:** el administrador elige "Cancelar" y el sistema no agrega nada.

## Reglas

- Código, nombre, categoría, precio y unidad de medida son obligatorios.
- El código no se puede repetir.
- El precio es mayor que 0.
- Un producto nuevo empieza con 0 existencias y mínimo 0 en cada tienda; las existencias se suben con una reposición (F-06).

## Estados

- **Cargando:** mientras se guarda, la opción "Guardar" muestra que está en proceso.
- **Vacío:** si falta un dato obligatorio, el sistema lo señala en el campo que falta y no guarda.
- **Error:** si el código ya existe, ve "Ya existe un producto con ese código"; si no se puede guardar, ve "No se pudo agregar el producto". En ambos casos los datos escritos se conservan.

## Datos

- Código, nombre, categoría, precio, unidad de medida y si es perecedero.

## Criterios de aceptación

- **CA-1** Dado el inventario abierto, cuando el administrador agrega "Yogur fresa 1L" con código P250, categoría Lácteos, precio $6.900 y unidad "und.", entonces ve "Producto agregado" y el yogur aparece en el inventario con 0 existencias.
- **CA-2** Dado un producto recién agregado, cuando un cajero abre el catálogo de venta, entonces lo ve como "Agotado".
- **CA-3** Dado que ya existe el código P001, cuando el administrador intenta agregar otro producto con P001, entonces ve "Ya existe un producto con ese código" y no se agrega.
- **CA-4** Dado el formulario sin nombre, cuando el administrador elige "Guardar", entonces el sistema señala el nombre como obligatorio y no guarda.
- **CA-5** Dado que el producto no se puede guardar, cuando el administrador elige "Guardar", entonces ve "No se pudo agregar el producto" y sus datos se conservan.

## Fuera de alcance

- Foto del producto.
- Crear categorías nuevas.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
