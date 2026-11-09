---
documento: prd
proyecto: NevaraFresh
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
---

# PRD · NevaraFresh

## Problema

NevaraFresh es una cadena de supermercados con 85 tiendas en 5 ciudades. Cada tienda usa un sistema distinto y la reposición se lleva en hojas de cálculo, así que nadie ve a tiempo el inventario de cada tienda: los productos más vendidos se agotan varias veces por semana y los perecederos se pierden por exceso de existencias (las mermas crecieron 18 % frente al año anterior).

## Usuarios

- **Cajero**: registrar las ventas de su tienda y saber qué productos tienen existencias antes de venderlos.
- **Administrador**: saber qué productos están bajos o agotados en cada tienda, reponerlos a tiempo y revisar las ventas de toda la cadena.

## Objetivos

- **O-01** El cajero registra una venta y el inventario de su tienda se actualiza solo. *Se cumple si* al confirmar la venta, las existencias de cada producto bajan exactamente en las unidades vendidas.
- **O-02** El cajero sabe qué productos tienen existencias en su tienda. *Se cumple si* cada producto muestra las existencias de su tienda y un producto agotado no se puede agregar a una venta.
- **O-03** El administrador detecta los productos en riesgo de agotarse. *Se cumple si* todo producto con existencias iguales o menores a su mínimo aparece como "Bajo stock" o "Agotado" en la tienda que corresponde.
- **O-04** El administrador repone existencias de un producto en una tienda. *Se cumple si* las existencias de esa tienda suben en las unidades registradas, las de las demás tiendas no cambian y la reposición queda registrada.
- **O-05** El administrador mantiene el catálogo de productos. *Se cumple si* un producto agregado, editado o eliminado se ve así en el inventario y en el catálogo de venta.
- **O-06** Cada usuario consulta las ventas que le corresponden. *Se cumple si* el administrador filtra las ventas de la cadena por tienda y fecha y ve el total vendido, y el cajero ve solo las ventas que él registró.
- **O-07** Cada usuario accede solo a lo de su rol. *Se cumple si* un cajero no puede ver el resumen de la cadena, el inventario de otras tiendas ni el historial de ventas de la cadena.

## Alcance

mvp visual (proximo, backend integrado) realizado en flutter con los requerimientos especificados


### Incluye

- Inicio de sesión con correo y contraseña, con acceso distinto para administrador y cajero, y acceso de demostración para cada rol.
- Registro de ventas: catálogo de la tienda con búsqueda y filtro por categoría, venta en curso con cantidades y total, confirmación y descuento automático de existencias.
- Consulta de las existencias de su tienda y de sus propias ventas, para el cajero.
- Resumen de la cadena para el administrador: productos registrados, productos en bajo stock, ventas del día y de la semana, y aviso de productos por agotarse.
- Inventario por tienda con búsqueda, filtros por categoría y tienda, y estado de cada producto: Disponible, Bajo stock o Agotado.
- Agregar, editar y eliminar productos. Al editar, el administrador define el mínimo de existencias del producto en cada tienda.
- Reposición en un solo paso: las unidades se suman de inmediato a las existencias de una tienda y la reposición queda registrada.
- Historial de ventas de la cadena con búsqueda y filtros por tienda y fecha.

### No incluye

- Crear tiendas y cuentas de usuario: vienen cargadas de antemano.
- Método de pago y descuentos en la venta.
- Exportar el historial de ventas a un archivo.
- Recuperación de contraseña.
- Reposición en dos pasos (pedido pendiente y recepción posterior).
- Pronóstico de demanda y sugerencias automáticas de pedido.
- Conexión con los sistemas de caja e inventario que ya usan las tiendas.
- Sensores de temperatura, pagos con tarjeta y tienda en línea.
- Uso desde el celular.

## Restricciones

- Equipo de cinco integrantes.
- La app se usa en computador.
- En la entrega del prototipo los datos son simulados y deben ser coherentes con el modelo de datos del equipo.


## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
