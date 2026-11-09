---
id: F-02
titulo: Registrar venta
version: 0.2.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-07, RF-08, RF-09]
depende_de: [F-01]
---

# F-02 · Registrar venta

## Objetivo

El cajero registra la venta de un cliente y las existencias de su tienda se descuentan solas.

## Historia de usuario

**Como** cajero, **quiero** registrar la venta de un cliente, **para** que las existencias de mi tienda se descuenten solas.

## Flujo principal

1. El cajero ve el catálogo de su tienda: cada producto con nombre, código, categoría, precio y existencias.
2. El cajero busca un producto por nombre o código, o filtra por categoría.
3. El cajero agrega productos a la venta en curso.
4. El cajero sube o baja la cantidad de cada producto en la venta en curso.
5. El sistema muestra las unidades, el subtotal y el total a pagar.
6. El cajero elige "Confirmar venta".
7. El sistema muestra un aviso con los productos, las unidades que se descuentan y el total a pagar.
8. El cajero confirma.
9. El sistema registra la venta con su número, descuenta las existencias de cada producto en la tienda y muestra "Venta registrada" con las existencias que cambiaron.
10. El sistema deja la venta en curso vacía para el siguiente cliente.

## Flujos alternos

- **A1 · Cancelar la venta:** el cajero elige "Cancelar venta", el sistema vacía la venta en curso y no cambia ninguna existencia.
- **A2 · Desistir en el aviso:** en el aviso de confirmación el cajero elige "Cancelar"; el aviso se cierra y la venta en curso sigue igual.
- **A3 · Quitar un producto:** el cajero baja a 0 la cantidad de un producto y este sale de la venta en curso.

## Reglas

- Un producto agotado no se puede agregar a la venta.
- La cantidad de un producto en la venta no puede superar sus existencias en la tienda.
- La venta solo se puede confirmar si tiene al menos un producto.
- El total es la suma de cantidad × precio de cada producto.
- Una venta queda a nombre del cajero que la registró y de su tienda.

## Estados

- **Cargando:** mientras se carga el catálogo, el cajero ve un indicador de carga.
- **Vacío:** si la venta en curso no tiene productos, el cajero ve "El carrito está vacío" y la confirmación no está disponible.
- **Error:** si la venta no se puede registrar, el cajero ve "No se pudo registrar la venta", la venta en curso se conserva y ninguna existencia cambia.

## Datos

- Producto: nombre, código, categoría, precio y existencias en la tienda.
- Venta: número, fecha y hora, cajero, tienda, productos con cantidad y subtotal, y total.

## Criterios de aceptación

```gherkin
Escenario: CA-1
  Dado un catálogo con "Leche entera 1L"
  Cuando el cajero escribe "P001" en la búsqueda
  Entonces ve solo ese producto

Escenario: CA-2
  Dado el catálogo completo
  Cuando el cajero elige la categoría "Lácteos"
  Entonces ve solo productos de esa categoría

Escenario: CA-3
  Dada una venta con Leche ×3 a $4.200, Arroz ×2 a $5.800 y Banano ×1 a $3.200
  Cuando el cajero la revisa
  Entonces ve 6 unidades y un total de $27.400

Escenario: CA-4
  Dada una Leche entera 1L con 30 existencias
  Cuando el cajero confirma una venta con 3 unidades
  Entonces ve "Venta registrada" y las existencias de la leche pasan a 27

Escenario: CA-5
  Dado un producto con 0 existencias
  Cuando el cajero lo ve en el catálogo
  Entonces aparece como "Agotado" y no lo puede agregar

Escenario: CA-6
  Dado un producto con 8 existencias que ya tiene 8 unidades en la venta
  Cuando el cajero intenta subir la cantidad
  Entonces la cantidad sigue en 8

Escenario: CA-7
  Dada una venta en curso con productos
  Cuando el cajero elige "Cancelar venta"
  Entonces la venta queda vacía y ninguna existencia cambia

Escenario: CA-8
  Dado el aviso de confirmación abierto
  Cuando el cajero elige "Cancelar"
  Entonces el aviso se cierra y la venta en curso conserva sus productos

Escenario: CA-9
  Dado que la venta no se puede registrar
  Cuando el cajero confirma
  Entonces ve "No se pudo registrar la venta", la venta en curso se conserva y ninguna existencia cambia
```

## Fuera de alcance

- Método de pago y descuentos.
- Anular una venta ya registrada.
- Imprimir el recibo.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
- 0.2.0 · 2026-11-07 · Se agrega la historia de usuario y los criterios de aceptación pasan a Gherkin.
