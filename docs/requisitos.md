---
documento: requisitos
proyecto: NevaraFresh
version: 0.1.0
fecha: 2026-11-07
estado: borrador
basado_en: prd 0.1.0
---

# Requisitos · NevaraFresh

## Funcionales

### O-01 · El cajero registra una venta y el inventario de su tienda se actualiza solo

- **RF-01** El sistema debe permitir que el cajero busque productos de su tienda por nombre o código. *Debe*
- **RF-02** El sistema debe permitir que el cajero filtre el catálogo de su tienda por categoría. *Debería*
- **RF-03** El sistema debe permitir que el cajero agregue productos a la venta en curso y cambie la cantidad de cada uno. *Debe*
- **RF-04** El sistema debe mostrar al cajero el total de unidades y el total a pagar de la venta en curso. *Debe*
- **RF-05** El sistema debe permitir que el cajero cancele la venta en curso. *Debería*
- **RF-06** El sistema debe permitir que el cajero confirme la venta en curso. *Debe*
- **RF-07** Al confirmar una venta, el sistema debe descontar de las existencias de la tienda las unidades vendidas de cada producto. *Debe*

### O-02 · El cajero sabe qué productos tienen existencias en su tienda

- **RF-08** El sistema debe mostrar al cajero las existencias de cada producto de su tienda en el catálogo de venta. *Debe*
- **RF-09** El sistema debe impedir que el cajero agregue a una venta un producto agotado o más unidades de las disponibles. *Debe*
- **RF-10** El sistema debe permitir que el cajero consulte el inventario completo de su tienda. *Debería*

### O-03 · El administrador detecta los productos en riesgo de agotarse

- **RF-11** El sistema debe marcar cada producto de una tienda como Disponible, Bajo stock o Agotado según sus existencias y su mínimo. *Debe*
- **RF-12** El sistema debe permitir que el administrador consulte el inventario de cualquier tienda. *Debe*
- **RF-13** El sistema debe permitir que el administrador busque en el inventario por nombre o código y lo filtre por categoría. *Debería*
- **RF-14** El sistema debe mostrar al administrador un resumen con la cantidad de productos registrados, los productos en bajo stock, las ventas del día y las ventas de la semana. *Debería*
- **RF-15** El sistema debe avisar al administrador qué productos están en bajo stock o agotados, y en qué tienda. *Debe*

### O-04 · El administrador repone existencias de un producto en una tienda

- **RF-16** El sistema debe permitir que el administrador sume unidades a las existencias de un producto en una tienda. *Debe*
- **RF-17** El sistema debe guardar cada reposición con la tienda, el producto, las unidades, la fecha y quién la registró. *Debe*

### O-05 · El administrador mantiene el catálogo de productos

- **RF-18** El sistema debe permitir que el administrador agregue un producto con código, nombre, categoría, precio y unidad de medida. *Debe*
- **RF-19** El sistema debe permitir que el administrador edite los datos de un producto y su mínimo de existencias en una tienda. *Debe*
- **RF-20** El sistema debe permitir que el administrador elimine un producto. *Debe*

### O-06 · Cada usuario consulta las ventas que le corresponden

- **RF-21** El sistema debe permitir que el administrador consulte las ventas de la cadena con fecha, número de venta, cajero, tienda, productos y total. *Debe*
- **RF-22** El sistema debe permitir que el administrador filtre las ventas por tienda y fecha, y las busque por número de venta o cajero. *Debería*
- **RF-23** El sistema debe mostrar al administrador la cantidad de ventas, el total vendido y el valor promedio por venta de las ventas filtradas. *Podría*
- **RF-24** El sistema debe permitir que el cajero consulte las ventas que él registró. *Debería*

### O-07 · Cada usuario accede solo a lo de su rol

- **RF-25** El sistema debe permitir que el usuario inicie sesión con correo y contraseña. *Debe*
- **RF-26** El sistema debe mostrar a cada usuario solo las opciones de su rol. *Debe*
- **RF-27** El sistema debe permitir que el usuario cierre sesión. *Debe*
- **RF-28** El sistema debe permitir entrar como administrador o como cajero de demostración sin escribir credenciales. *Podría*

## No funcionales

- **RNF-01** La app funciona en el navegador de un computador con una ventana de al menos 1280 px de ancho. (O-01, O-03) *Debe*
- **RNF-02** Toda la interfaz está en español y los precios se muestran en pesos colombianos sin decimales, con separador de miles (por ejemplo, $4.200). (O-01) *Debe*
- **RNF-03** Registrar una venta de un producto toma como máximo tres acciones desde el catálogo: agregar, confirmar y aceptar el aviso de confirmación. (O-01) *Debería*
- **RNF-04** Después de confirmar una venta o registrar una reposición, las existencias nuevas se ven en menos de 2 segundos. (O-01, O-04) *Debe*
- **RNF-05** Las existencias de cada tienda son independientes: una venta o una reposición en una tienda no cambia las existencias de las demás. (O-04) *Debe*

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
