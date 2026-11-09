import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/usuario.dart';
import 'package:proyectof_nevarafresh/services/auth_service.dart';
import 'package:proyectof_nevarafresh/services/memoria_datos.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';

void main() {
  final auth = AuthService.instancia;

  setUp(() {
    MemoriaDatos.demora = Duration.zero;
    MemoriaDatos.instancia.reiniciar();
    auth.cerrarSesion();
  });

  test('F-01 CA-1: el administrador inicia sesión', () async {
    final u = await auth.iniciarSesion('laura.gomez@nevarafresh.com', 'nevara123');
    expect(u.rol, Rol.administrador);
    expect(auth.usuarioActual?.id, 'u1');
  });

  test('F-01 CA-4: contraseña equivocada da error', () async {
    await expectLater(
      () => auth.iniciarSesion('laura.gomez@nevarafresh.com', 'otra'),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'Correo o contraseña incorrectos')),
    );
  });

  test('F-01 CA-3: demo cajero entra como cajero', () async {
    final u = await auth.entrarDemo(Rol.cajero);
    expect(u.rol, Rol.cajero);
    expect(u.idTienda, 't1');
  });
}
