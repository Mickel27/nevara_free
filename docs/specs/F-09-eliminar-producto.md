---
id: F-09
titulo: Eliminar producto
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-20]
depende_de: [F-05]
---

# F-09 · Eliminar producto

## Objetivo

El administrador quita del catálogo un producto que la cadena ya no vende.

## Flujo principal

1. En el inventario, el administrador elige eliminar un producto.
2. El sistema pide confirmar: "¿Eliminar este producto? Dejará de aparecer en todas las tiendas".
3. El administrador confirma.
4. El sistema quita el producto del inventario de todas las tiendas y del catálogo de venta, y muestra "Producto eliminado".

## Flujos alternos

- **A1 · Cancelar:** el administrador elige "Cancelar" y el producto sigue igual.

## Reglas

- Eliminar un producto lo quita de todas las tiendas.
- Las ventas ya registradas con ese producto se conservan en el historial con su nombre y su precio.

## Estados

- **Cargando:** mientras se elimina, la confirmación muestra que está en proceso.
- **Vacío:** no aplica; siempre hay un producto elegido.
- **Error:** si no se puede eliminar, ve "No se pudo eliminar el producto" y el producto sigue en el inventario.

## Datos

- Código y nombre del producto.

## Criterios de aceptación

- **CA-1** Dado "Agua 600 ml" en el inventario, cuando el administrador lo elimina y confirma, entonces ve "Producto eliminado" y el agua ya no aparece en ninguna tienda ni en el catálogo de venta.
- **CA-2** Dada una venta registrada con "Agua 600 ml", cuando el administrador elimina el agua, entonces esa venta sigue en el historial con el agua en sus productos.
- **CA-3** Dada la confirmación abierta, cuando el administrador elige "Cancelar", entonces el producto sigue en el inventario.
- **CA-4** Dado que el producto no se puede eliminar, cuando el administrador confirma, entonces ve "No se pudo eliminar el producto" y el producto sigue en el inventario.

## Fuera de alcance

- Recuperar un producto eliminado.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
