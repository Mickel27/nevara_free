---
id: F-03
titulo: Stock de mi tienda
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-10]
depende_de: [F-01]
---

# F-03 · Stock de mi tienda

## Objetivo

El cajero consulta las existencias de todos los productos de su tienda, sin poder modificarlas.

## Flujo principal

1. El cajero elige "Stock de mi tienda" en el menú.
2. El sistema muestra los productos de su tienda con código, nombre, categoría, existencias, mínimo y estado.
3. El cajero busca por nombre o código, o filtra por categoría.

## Flujos alternos

- **A1 · Sin coincidencias:** si la búsqueda no encuentra productos, el sistema muestra "No hay productos que coincidan".

## Reglas

- El cajero solo ve los productos de su tienda.
- El cajero no puede agregar, editar, eliminar ni reponer productos.
- El estado se calcula igual que en el inventario del administrador: Agotado con 0 existencias, Bajo stock con existencias iguales o menores al mínimo, Disponible en otro caso.

## Estados

- **Cargando:** el cajero ve un indicador de carga.
- **Vacío:** si la tienda no tiene productos, ve "Tu tienda no tiene productos registrados".
- **Error:** si no se pueden cargar los productos, ve "No se pudo cargar el inventario" y la opción de reintentar.

## Datos

- Producto: código, nombre, categoría, existencias, mínimo y estado en su tienda.

## Criterios de aceptación

- **CA-1** Dado un cajero de Sede Norte, cuando abre "Stock de mi tienda", entonces ve solo productos de Sede Norte con sus existencias y su estado.
- **CA-2** Dado un producto con 6 existencias y mínimo 10, cuando el cajero lo ve, entonces aparece como "Bajo stock".
- **CA-3** Dada una búsqueda sin coincidencias, cuando el cajero escribe un nombre que no existe, entonces ve "No hay productos que coincidan".
- **CA-4** Dada la sección abierta, cuando el cajero revisa un producto, entonces no tiene opciones para editarlo, eliminarlo ni reponerlo.
- **CA-5** Dado que el inventario no se puede cargar, cuando el cajero abre la sección, entonces ve "No se pudo cargar el inventario" y puede reintentar.

## Fuera de alcance

- Ver el inventario de otras tiendas.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
