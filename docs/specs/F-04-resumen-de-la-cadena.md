---
id: F-04
titulo: Resumen de la cadena
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-14, RF-15]
depende_de: [F-01]
---

# F-04 · Resumen de la cadena

## Objetivo

El administrador ve de un vistazo cómo van las tiendas y qué productos están por agotarse.

## Flujo principal

1. El administrador entra al Dashboard.
2. El sistema muestra cuatro indicadores: productos registrados, productos con bajo stock, ventas del día (valor y cantidad de transacciones) y número de tiendas.
3. El sistema muestra las ventas de cada día de la semana y la variación frente a la semana anterior.
4. El sistema muestra la lista de productos con poco inventario: nombre, tienda, existencias, mínimo y estado.
5. Si hay productos bajos o agotados, el sistema muestra un aviso con la tienda y la cantidad de productos afectados.
6. El administrador elige "Ver inventario" y el sistema abre el inventario.

## Flujos alternos

- **A1 · Filtrar por tienda:** el administrador elige una tienda y los indicadores, las ventas y la lista muestran solo esa tienda. "Todas las tiendas" vuelve a la cadena completa.

## Reglas

- Un producto entra en la lista de poco inventario si en alguna tienda tiene existencias iguales o menores a su mínimo.
- Las ventas del día suman las ventas registradas desde las 00:00 de hoy.

## Estados

- **Cargando:** el administrador ve un indicador en cada bloque mientras se cargan los datos.
- **Vacío:** si ningún producto está bajo o agotado, la lista dice "Todos los productos tienen existencias suficientes" y no aparece el aviso.
- **Error:** si no se pueden cargar los datos, ve "No se pudo cargar el resumen" y la opción de reintentar.

## Datos

- Productos registrados, productos con bajo stock, ventas del día, transacciones del día, tiendas, ventas por día de la semana y productos con poco inventario por tienda.

## Criterios de aceptación

- **CA-1** Dado que Sede Norte tiene 3 productos en bajo stock y 1 agotado, cuando el administrador abre el Dashboard, entonces ve el aviso "Sede Norte: 3 productos en bajo stock y 1 agotado".
- **CA-2** Dado "Pan tajado 500 g" con 0 existencias y mínimo 12 en Sede Norte, cuando el administrador revisa la lista, entonces lo ve como "Agotado" con "0 / 12".
- **CA-3** Dado el Dashboard abierto, cuando el administrador elige "Sede Sur", entonces los indicadores y la lista muestran solo datos de Sede Sur.
- **CA-4** Dado el Dashboard abierto, cuando el administrador elige "Ver inventario", entonces se abre el inventario.
- **CA-5** Dado que ningún producto está bajo su mínimo, cuando el administrador abre el Dashboard, entonces no ve el aviso y la lista dice "Todos los productos tienen existencias suficientes".
- **CA-6** Dado que los datos no se pueden cargar, cuando el administrador abre el Dashboard, entonces ve "No se pudo cargar el resumen" y puede reintentar.

## Fuera de alcance

- Pronóstico de demanda.
- Elegir otro rango de fechas para las ventas.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
