---
id: F-11
titulo: Mis ventas
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-24]
depende_de: [F-02]
---

# F-11 · Mis ventas

## Objetivo

El cajero revisa las ventas que él mismo registró hoy.

## Flujo principal

1. El cajero elige "Mis ventas" en el menú.
2. El sistema muestra las ventas que registró hoy, de la más reciente a la más antigua, con hora, número de venta, productos vendidos y total.
3. El sistema muestra cuántas ventas lleva y el total vendido.

## Flujos alternos

- **A1 · Buscar:** el cajero busca por número de venta y el sistema muestra solo esa venta.

## Reglas

- El cajero solo ve sus propias ventas, no las de otros cajeros ni las de otras tiendas.

## Estados

- **Cargando:** el cajero ve un indicador de carga.
- **Vacío:** si no ha registrado ventas hoy, ve "Aún no has registrado ventas hoy".
- **Error:** si no se pueden cargar, ve "No se pudieron cargar tus ventas" y la opción de reintentar.

## Datos

- Venta: hora, número, productos con cantidad y total.

## Criterios de aceptación

- **CA-1** Dado que Carlos Ruiz registró las ventas V-1042 y V-1043, cuando abre "Mis ventas", entonces ve esas dos ventas y ninguna de otro cajero.
- **CA-2** Dada una venta recién confirmada, cuando el cajero abre "Mis ventas", entonces la ve de primera.
- **CA-3** Dado un cajero sin ventas hoy, cuando abre "Mis ventas", entonces ve "Aún no has registrado ventas hoy".
- **CA-4** Dado que las ventas no se pueden cargar, cuando el cajero abre la sección, entonces ve "No se pudieron cargar tus ventas" y puede reintentar.

## Fuera de alcance

- Ver ventas de días anteriores.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
