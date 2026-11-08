---
id: F-01
titulo: Inicio de sesión
version: 0.1.0
fecha: 2026-11-07
estado: borrador
autores: [Jeanfer Rivera, Santiago Samboni, Miguel Ángel Blanco, Luis Miguel Delgado, Santiago Sierra]
requisitos: [RF-25, RF-26, RF-27, RF-28]
depende_de: []
---

# F-01 · Inicio de sesión

## Objetivo

El cajero y el administrador entran a la app con su cuenta y ven solo las opciones de su rol.

## Flujo principal

1. El usuario escribe su correo y su contraseña.
2. El usuario elige "Iniciar sesión".
3. El sistema valida la cuenta y lee el rol del usuario.
4. Si es administrador, el sistema abre el resumen de la cadena con el menú Dashboard, Inventario e Historial de ventas.
5. Si es cajero, el sistema abre el punto de venta de su tienda con el menú Punto de venta, Stock de mi tienda y Mis ventas.

## Flujos alternos

- **A1 · Acceso de demostración:** el usuario elige "Demo administrador" o "Demo cajero" y el sistema entra con la cuenta de demostración de ese rol, sin pedir credenciales.
- **A2 · Cerrar sesión:** desde cualquier sección, el usuario elige cerrar sesión y el sistema vuelve al inicio de sesión.

## Reglas

- El correo y la contraseña son obligatorios.
- Un usuario inactivo no puede entrar.
- Después de cerrar sesión, volver atrás no regresa a la app.

## Estados

- **Cargando:** mientras valida la cuenta, la opción "Iniciar sesión" muestra que está en proceso y no se puede volver a elegir.
- **Vacío:** si falta el correo o la contraseña, el sistema lo señala en el campo que falta.
- **Error:** si las credenciales no coinciden, el usuario ve "Correo o contraseña incorrectos" y puede intentar de nuevo.

## Datos

- Correo, contraseña, nombre del usuario, rol y tienda.

## Criterios de aceptación

- **CA-1** Dado un administrador con cuenta activa, cuando inicia sesión con su correo y contraseña, entonces ve el resumen de la cadena y su menú tiene Dashboard, Inventario e Historial de ventas.
- **CA-2** Dado un cajero con cuenta activa, cuando inicia sesión, entonces ve el punto de venta de su tienda y su menú tiene Punto de venta, Stock de mi tienda y Mis ventas.
- **CA-3** Dado el inicio de sesión, cuando el usuario elige "Demo cajero", entonces entra como cajero de demostración sin escribir credenciales.
- **CA-4** Dado un correo con una contraseña equivocada, cuando el usuario intenta entrar, entonces ve "Correo o contraseña incorrectos" y sigue en el inicio de sesión.
- **CA-5** Dado un usuario dentro de la app, cuando cierra sesión, entonces vuelve al inicio de sesión y volver atrás no lo regresa a la app.

## Fuera de alcance

- Recuperar la contraseña.
- Crear cuentas nuevas.

## Preguntas abiertas

- Ninguna.

## Historial

- 0.1.0 · 2026-11-07 · Primera versión.
