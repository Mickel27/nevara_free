---
id: F-08
titulo: Editar producto
version: 0.2.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-19]
depende_de: [F-05]
---

# F-08 · Editar producto

## Objetivo

El administrador corrige los datos de un producto y define su mínimo de existencias en la tienda que está revisando.

## Historia de usuario

**Como** administrador, **quiero** editar los datos de un producto y su mínimo en una tienda, **para** mantener el catálogo al día.

## Flujo principal

1. En el inventario de una tienda, el administrador elige editar un producto.
2. El sistema muestra los datos actuales: código, nombre, categoría, precio, unidad de medida, si es perecedero y el mínimo de existencias en esa tienda.
3. El administrador cambia los datos y elige "Guardar".
4. El sistema guarda los cambios y muestra "Producto actualizado".
5. Los datos nuevos se ven en el inventario y en el catálogo de venta; el estado del producto se vuelve a calcular con el mínimo nuevo.

## Flujos alternos

- **A1 · Cancelar:** el administrador elige "Cancelar" y nada cambia.

## Reglas

- Los datos del producto (nombre, categoría, precio, unidad) son de la cadena: el cambio se ve en todas las tiendas.
- El mínimo de existencias es de la tienda que se está revisando: solo cambia ahí.
- Las existencias no se editan aquí; se suben con una reposición (F-06) y bajan con las ventas (F-02).
- Las mismas reglas de datos obligatorios, código único y precio mayor que 0 de F-07.

## Estados

- **Cargando:** mientras se guarda, la opción "Guardar" muestra que está en proceso.
- **Vacío:** si se borra un dato obligatorio, el sistema lo señala y no guarda.
- **Error:** si no se puede guardar, ve "No se pudo actualizar el producto" y los datos escritos se conservan.

## Datos

- Código, nombre, categoría, precio, unidad de medida, si es perecedero y mínimo de existencias en la tienda.

## Criterios de aceptación

```gherkin
Escenario: CA-1
  Dado "Arroz blanco 1 kg" a $5.800
  Cuando el administrador cambia el precio a $6.000 y guarda
  Entonces ve "Producto actualizado" y el arroz aparece a $6.000 en el inventario y en el catálogo de venta

Escenario: CA-2
  Dado "Banano ×kg" con 42 existencias y mínimo 12 en Sede Norte
  Cuando el administrador cambia el mínimo a 45
  Entonces el banano pasa a "Bajo stock" en Sede Norte y su estado en las demás tiendas no cambia

Escenario: CA-3
  Dado el formulario de edición
  Cuando el administrador borra el nombre y elige "Guardar"
  Entonces el sistema señala el nombre como obligatorio y no guarda

Escenario: CA-4
  Dado que el producto no se puede guardar
  Cuando el administrador elige "Guardar"
  Entonces ve "No se pudo actualizar el producto" y sus cambios se conservan
```

## Fuera de alcance

- Editar las existencias a mano.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
- 0.2.0 · 2026-11-07 · Se agrega la historia de usuario y los criterios de aceptación pasan a Gherkin.
