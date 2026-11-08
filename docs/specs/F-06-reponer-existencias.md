---
id: F-06
titulo: Reponer existencias
version: 0.2.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-16, RF-17]
depende_de: [F-05]
---

# F-06 · Reponer existencias

## Objetivo

El administrador suma unidades a las existencias de un producto en una tienda, en un solo paso.

## Historia de usuario

**Como** administrador, **quiero** sumar unidades a las existencias de un producto en una tienda, **para** reponerlo antes de que se agote.

## Flujo principal

1. En el inventario de una tienda, el administrador elige reponer un producto.
2. El sistema muestra un aviso con el producto, la tienda, las existencias actuales y el mínimo.
3. El administrador escribe las unidades a reponer.
4. El sistema muestra cómo quedarían las existencias (actuales + unidades a reponer).
5. El administrador elige "Registrar reposición".
6. El sistema suma las unidades a las existencias de esa tienda, guarda la reposición y muestra "Stock actualizado" con el cambio.

## Flujos alternos

- **A1 · Cancelar:** el administrador elige "Cancelar" y el sistema cierra el aviso sin cambiar las existencias.

## Reglas

- Las unidades a reponer son un número entero mayor que 0.
- Solo cambian las existencias de la tienda elegida; las demás tiendas no cambian.
- Cada reposición guarda la tienda, el producto, las unidades, la fecha y el administrador que la registró.
- Después de reponer, el estado del producto se vuelve a calcular.

## Estados

- **Cargando:** mientras se registra, la opción "Registrar reposición" muestra que está en proceso.
- **Vacío:** si las unidades están vacías o en 0, la opción "Registrar reposición" no está disponible.
- **Error:** si no se puede registrar, el administrador ve "No se pudo registrar la reposición" y las existencias no cambian.

## Datos

- Producto, tienda, existencias actuales, mínimo, unidades a reponer, fecha y administrador.

## Criterios de aceptación

```gherkin
Escenario: CA-1
  Dado "Huevos AA ×30" con 8 existencias en Sede Norte
  Cuando el administrador repone 24 unidades
  Entonces ve 32 existencias y el estado pasa a "Disponible"

Escenario: CA-2
  Dado "Huevos AA ×30" en Sede Norte y en Sede Sur
  Cuando el administrador repone en Sede Norte
  Entonces las existencias de Sede Sur no cambian

Escenario: CA-3
  Dado el aviso abierto
  Cuando el administrador escribe 0 unidades
  Entonces no puede registrar la reposición

Escenario: CA-4
  Dado el aviso abierto
  Cuando el administrador elige "Cancelar"
  Entonces el aviso se cierra y las existencias no cambian

Escenario: CA-5
  Dado que la reposición no se puede registrar
  Cuando el administrador la confirma
  Entonces ve "No se pudo registrar la reposición" y las existencias no cambian
```

## Fuera de alcance

- Pedidos pendientes y recepción posterior de mercancía.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
- 0.2.0 · 2026-11-07 · Se agrega la historia de usuario y los criterios de aceptación pasan a Gherkin.
