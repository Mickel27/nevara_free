---
id: F-05
titulo: Inventario por tienda
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-11, RF-12, RF-13]
depende_de: [F-01]
---

# F-05 · Inventario por tienda

## Objetivo

El administrador revisa las existencias de cualquier tienda y ve qué productos están bajos o agotados.

## Flujo principal

1. El administrador elige "Inventario" en el menú.
2. El sistema muestra los productos de la tienda seleccionada con código, nombre, categoría, precio, existencias, mínimo y estado.
3. El administrador cambia de tienda y el sistema muestra las existencias de esa tienda.
4. El administrador busca por nombre o código, o filtra por categoría.
5. El sistema muestra los productos de diez en diez y el administrador pasa de página.

## Flujos alternos

- **A1 · Sin coincidencias:** si la búsqueda o el filtro no encuentran productos, el sistema muestra "No hay productos que coincidan".

## Reglas

- Las existencias son independientes por tienda: el mismo producto puede tener cantidades distintas en cada tienda.
- Estado de un producto en una tienda: Agotado con 0 existencias, Bajo stock con existencias iguales o menores al mínimo, Disponible en otro caso.
- Desde cada producto se puede editar (F-08), reponer (F-06) o eliminar (F-09).

## Estados

- **Cargando:** el administrador ve un indicador de carga.
- **Vacío:** si la tienda no tiene productos, ve "Esta tienda no tiene productos registrados".
- **Error:** si no se puede cargar el inventario, ve "No se pudo cargar el inventario" y la opción de reintentar.

## Datos

- Producto: código, nombre, categoría y precio.
- Existencias en la tienda: cantidad, mínimo y estado.

## Criterios de aceptación

- **CA-1** Dado "Huevos AA ×30" con 8 existencias y mínimo 10 en Sede Norte, cuando el administrador abre el inventario de Sede Norte, entonces lo ve como "Bajo stock".
- **CA-2** Dado "Leche entera 1L" con 30 existencias en Sede Norte y 12 en Sede Sur, cuando el administrador cambia de Sede Norte a Sede Sur, entonces la leche pasa de mostrar 30 a mostrar 12.
- **CA-3** Dado el inventario abierto, cuando el administrador filtra por "Frutas", entonces ve solo productos de esa categoría.
- **CA-4** Dada una tienda con 25 productos, cuando el administrador abre su inventario, entonces ve 10 productos y puede pasar a la página 2.
- **CA-5** Dada una búsqueda sin coincidencias, cuando el administrador escribe un código que no existe, entonces ve "No hay productos que coincidan".
- **CA-6** Dado que el inventario no se puede cargar, cuando el administrador abre la sección, entonces ve "No se pudo cargar el inventario" y puede reintentar.

## Fuera de alcance

- Ver el inventario de todas las tiendas a la vez.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
