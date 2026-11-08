---
id: F-10
titulo: Historial de ventas
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-21, RF-22, RF-23]
depende_de: [F-02]
---

# F-10 · Historial de ventas

## Objetivo

El administrador revisa las ventas de toda la cadena y cuánto se vendió.

## Flujo principal

1. El administrador elige "Historial de ventas" en el menú.
2. El sistema muestra las ventas de hoy de todas las tiendas, de la más reciente a la más antigua, con fecha y hora, número de venta, cajero, tienda, productos vendidos y total.
3. El sistema muestra la cantidad de ventas, el total vendido y el valor promedio por venta.
4. El administrador filtra por tienda y por fecha, o busca por número de venta o por cajero.
5. El sistema actualiza las ventas y los totales según el filtro.

## Flujos alternos

- **A1 · Sin ventas:** si no hay ventas para el filtro, el sistema muestra "No hay ventas para este filtro" y los totales en 0.

## Reglas

- El valor promedio es el total vendido dividido entre la cantidad de ventas.
- Una venta recién registrada aparece al volver a abrir o al refrescar el historial.

## Estados

- **Cargando:** el administrador ve un indicador de carga.
- **Vacío:** "No hay ventas para este filtro", con los totales en 0.
- **Error:** si no se pueden cargar las ventas, ve "No se pudo cargar el historial" y la opción de reintentar.

## Datos

- Venta: fecha y hora, número, cajero, tienda, productos con cantidad, y total.

## Criterios de aceptación

- **CA-1** Dadas 138 ventas hoy por $4.860.200, cuando el administrador abre el historial, entonces ve 138 ventas, total vendido $4.860.200 y valor promedio $35.219.
- **CA-2** Dado el historial abierto, cuando el administrador filtra por "Sede Sur", entonces ve solo ventas de Sede Sur y los totales cambian.
- **CA-3** Dado el historial abierto, cuando el administrador busca "V-1043", entonces ve solo esa venta.
- **CA-4** Dado un día sin ventas, cuando el administrador lo elige en el filtro de fecha, entonces ve "No hay ventas para este filtro" y los totales en 0.
- **CA-5** Dado que las ventas no se pueden cargar, cuando el administrador abre el historial, entonces ve "No se pudo cargar el historial" y puede reintentar.

## Fuera de alcance

- Exportar el historial a un archivo.
- Anular ventas.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
