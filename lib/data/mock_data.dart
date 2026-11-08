// Datos simulados del prototipo, coherentes con docs/modelo.md.
// Solo los servicios (lib/services/) leen este archivo.

import '../models/categoria.dart';
import '../models/detalle_venta.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import '../models/usuario.dart';
import '../models/venta.dart';

const List<Tienda> tiendasIniciales = [
  Tienda(id: 't1', nombre: 'Sede Norte', ciudad: 'Cali'),
  Tienda(id: 't2', nombre: 'Sede Sur', ciudad: 'Bogotá'),
  Tienda(id: 't3', nombre: 'Sede Laureles', ciudad: 'Medellín'),
  Tienda(id: 't4', nombre: 'Sede Centro', ciudad: 'Bucaramanga'),
  Tienda(id: 't5', nombre: 'Sede El Prado', ciudad: 'Barranquilla'),
];

const List<Usuario> usuariosIniciales = [
  Usuario(id: 'u1', nombre: 'Laura Gómez', correo: 'laura.gomez@nevarafresh.com', rol: Rol.administrador),
  Usuario(id: 'u2', nombre: 'Carlos Ruiz', correo: 'carlos.ruiz@nevarafresh.com', rol: Rol.cajero, idTienda: 't1'),
  Usuario(id: 'u3', nombre: 'Ana Torres', correo: 'ana.torres@nevarafresh.com', rol: Rol.cajero, idTienda: 't2'),
  Usuario(id: 'u4', nombre: 'Jorge Pérez', correo: 'jorge.perez@nevarafresh.com', rol: Rol.cajero, idTienda: 't3'),
  Usuario(id: 'u5', nombre: 'María López', correo: 'maria.lopez@nevarafresh.com', rol: Rol.cajero, idTienda: 't4'),
  Usuario(id: 'u6', nombre: 'Luis Martínez', correo: 'luis.martinez@nevarafresh.com', rol: Rol.cajero, idTienda: 't5'),
];

/// Contraseñas de prueba del prototipo. Solo existen aquí.
const Map<String, String> contrasenasDePrueba = {
  'laura.gomez@nevarafresh.com': 'nevara123',
  'carlos.ruiz@nevarafresh.com': 'nevara123',
  'ana.torres@nevarafresh.com': 'nevara123',
  'jorge.perez@nevarafresh.com': 'nevara123',
  'maria.lopez@nevarafresh.com': 'nevara123',
  'luis.martinez@nevarafresh.com': 'nevara123',
};

/// Cuentas que usan los botones "Demo administrador" y "Demo cajero".
const String idUsuarioDemoAdmin = 'u1';
const String idUsuarioDemoCajero = 'u2';

const List<Categoria> categoriasIniciales = [
  Categoria(id: 'c1', nombre: 'Lácteos'),
  Categoria(id: 'c2', nombre: 'Granos'),
  Categoria(id: 'c3', nombre: 'Huevos'),
  Categoria(id: 'c4', nombre: 'Panadería'),
  Categoria(id: 'c5', nombre: 'Frutas'),
  Categoria(id: 'c6', nombre: 'Verduras'),
  Categoria(id: 'c7', nombre: 'Bebidas'),
];

const List<Producto> productosIniciales = [
  Producto(id: 'p1', sku: 'P001', nombre: 'Leche entera 1L', idCategoria: 'c1', precio: 4200, unidadMedida: 'und.', esPerecedero: true),
  Producto(id: 'p2', sku: 'P002', nombre: 'Arroz blanco 1 kg', idCategoria: 'c2', precio: 5800, unidadMedida: 'und.'),
  Producto(id: 'p3', sku: 'P003', nombre: 'Huevos AA ×30', idCategoria: 'c3', precio: 18900, unidadMedida: 'und.', esPerecedero: true),
  Producto(id: 'p4', sku: 'P004', nombre: 'Pan tajado 500 g', idCategoria: 'c4', precio: 6500, unidadMedida: 'und.', esPerecedero: true),
  Producto(id: 'p5', sku: 'P005', nombre: 'Banano ×kg', idCategoria: 'c5', precio: 3200, unidadMedida: 'kg', esPerecedero: true),
  Producto(id: 'p6', sku: 'P006', nombre: 'Tomate chonto ×kg', idCategoria: 'c6', precio: 4800, unidadMedida: 'kg', esPerecedero: true),
  Producto(id: 'p7', sku: 'P007', nombre: 'Gaseosa 1,5 L', idCategoria: 'c7', precio: 5500, unidadMedida: 'und.'),
  Producto(id: 'p8', sku: 'P008', nombre: 'Queso campesino 500 g', idCategoria: 'c1', precio: 12900, unidadMedida: 'und.', esPerecedero: true),
  Producto(id: 'p9', sku: 'P009', nombre: 'Manzana roja ×kg', idCategoria: 'c5', precio: 7900, unidadMedida: 'kg', esPerecedero: true),
  Producto(id: 'p10', sku: 'P010', nombre: 'Agua 600 ml', idCategoria: 'c7', precio: 1800, unidadMedida: 'und.'),
];

// Existencias y mínimo de p1..p10, por tienda.
// Sede Norte usa los valores del Figma: Huevos, Tomate y Agua en bajo stock; Pan agotado.
const Map<String, List<List<int>>> _existenciasPorTienda = {
  't1': [[30, 10], [54, 15], [8, 10], [0, 12], [42, 12], [6, 10], [60, 20], [15, 8], [22, 10], [9, 15]],
  't2': [[7, 10], [40, 15], [25, 10], [18, 12], [35, 12], [20, 10], [48, 20], [12, 8], [30, 10], [40, 15]],
  't3': [[28, 10], [36, 15], [20, 10], [15, 12], [30, 12], [18, 10], [55, 20], [14, 8], [26, 10], [50, 15]],
  't4': [[33, 10], [45, 15], [22, 10], [20, 12], [38, 12], [25, 10], [44, 20], [10, 8], [24, 10], [35, 15]],
  't5': [[26, 10], [38, 15], [18, 10], [16, 12], [40, 12], [22, 10], [52, 20], [11, 8], [28, 10], [45, 15]],
};

List<Inventario> inventarioInicial() {
  final lista = <Inventario>[];
  _existenciasPorTienda.forEach((idTienda, valores) {
    for (var i = 0; i < productosIniciales.length; i++) {
      lista.add(Inventario(
        idTienda: idTienda,
        idProducto: productosIniciales[i].id,
        existencias: valores[i][0],
        minimo: valores[i][1],
      ));
    }
  });
  return lista;
}

DetalleVenta _detalle(String idProducto, int cantidad) {
  final p = productosIniciales.firstWhere((p) => p.id == idProducto);
  return DetalleVenta(
    idProducto: p.id,
    nombreProducto: p.nombre,
    cantidad: cantidad,
    precioUnitario: p.precio,
  );
}

/// Ventas de los últimos 7 días (para el gráfico del dashboard)
/// y las ventas de hoy del Figma (V-1036 a V-1042).
List<Venta> ventasIniciales() {
  final hoy = DateTime.now();
  DateTime a(int diasAtras, int hora, int minuto) =>
      DateTime(hoy.year, hoy.month, hoy.day - diasAtras, hora, minuto);

  final ventas = <Venta>[];
  var numero = 1024;

  // Días anteriores: dos ventas por día.
  const cajeroDeTienda = {'t1': 'u2', 't2': 'u3', 't3': 'u4', 't4': 'u5', 't5': 'u6'};
  for (var d = 6; d >= 1; d--) {
    final tiendaA = 't${(d % 5) + 1}';
    final tiendaB = 't${((d + 2) % 5) + 1}';
    ventas.add(Venta(
      id: 'v$numero', numero: 'V-$numero', idTienda: tiendaA, idUsuario: cajeroDeTienda[tiendaA]!,
      fechaHora: a(d, 10, 15), detalles: [_detalle('p2', d), _detalle('p7', 2)],
    ));
    numero++;
    ventas.add(Venta(
      id: 'v$numero', numero: 'V-$numero', idTienda: tiendaB, idUsuario: cajeroDeTienda[tiendaB]!,
      fechaHora: a(d, 16, 40), detalles: [_detalle('p1', 3), _detalle('p5', d + 1)],
    ));
    numero++;
  }

  // Hoy: las ventas del Figma.
  ventas.addAll([
    Venta(id: 'v1036', numero: 'V-1036', idTienda: 't3', idUsuario: 'u4', fechaHora: a(0, 10, 12), detalles: [_detalle('p8', 1), _detalle('p3', 1)]),
    Venta(id: 'v1037', numero: 'V-1037', idTienda: 't5', idUsuario: 'u6', fechaHora: a(0, 10, 30), detalles: [_detalle('p1', 2), _detalle('p4', 2)]),
    Venta(id: 'v1038', numero: 'V-1038', idTienda: 't2', idUsuario: 'u3', fechaHora: a(0, 10, 47), detalles: [_detalle('p6', 2), _detalle('p2', 1)]),
    Venta(id: 'v1039', numero: 'V-1039', idTienda: 't4', idUsuario: 'u5', fechaHora: a(0, 11, 2), detalles: [_detalle('p9', 2), _detalle('p5', 3)]),
    Venta(id: 'v1040', numero: 'V-1040', idTienda: 't3', idUsuario: 'u4', fechaHora: a(0, 11, 20), detalles: [_detalle('p7', 4), _detalle('p10', 6)]),
    Venta(id: 'v1041', numero: 'V-1041', idTienda: 't2', idUsuario: 'u3', fechaHora: a(0, 11, 35), detalles: [_detalle('p3', 1), _detalle('p8', 1)]),
    Venta(id: 'v1042', numero: 'V-1042', idTienda: 't1', idUsuario: 'u2', fechaHora: a(0, 11, 41), detalles: [_detalle('p1', 3), _detalle('p4', 1)]),
  ]);
  return ventas;
}

/// Número de la próxima venta.
const int siguienteNumeroVentaInicial = 1043;
