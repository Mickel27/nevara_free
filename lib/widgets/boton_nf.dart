import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum VariacionBoton { principal, secundario, peligro }

/// Botón de la galería. Si [onPressed] es null o [cargando] es true,
/// queda deshabilitado.
class BotonNF extends StatelessWidget {
  final String texto;
  final VariacionBoton variante;
  final IconData? icono;
  final VoidCallback? onPressed;
  final bool cargando;
  final bool expandido;
  final double alto;

  const BotonNF({
    super.key,
    required this.texto,
    required this.onPressed,
    this.variante = VariacionBoton.principal,
    this.icono,
    this.cargando = false,
    this.expandido = false,
    this.alto = 42,
  });

  @override
  Widget build(BuildContext context) {
    final habilitado = onPressed != null && !cargando;

    Color fondo;
    Color texto0;
    BorderSide borde;
    if (!habilitado) {
      fondo = const Color(0xFFF1F5F9);
      texto0 = AppColors.textMuted;
      borde = const BorderSide(color: AppColors.border);
    } else if (variante == VariacionBoton.peligro) {
      fondo = AppColors.dangerBg;
      texto0 = AppColors.danger;
      borde = const BorderSide(color: AppColors.statusRedBorder);
    } else if (variante == VariacionBoton.secundario) {
      fondo = AppColors.surface;
      texto0 = AppColors.textPrimary;
      borde = const BorderSide(color: AppColors.border);
    } else {
      fondo = AppColors.primary;
      texto0 = Colors.white;
      borde = BorderSide.none;
    }

    final contenido = Row(
      mainAxisSize: expandido ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cargando) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: texto0),
          ),
          const SizedBox(width: 8),
        ] else if (icono != null) ...[
          Icon(icono, size: 18, color: texto0),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: texto0),
          ),
        ),
      ],
    );

    final boton = Material(
      color: fondo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: borde),
      child: InkWell(
        onTap: habilitado ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: alto,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          child: contenido,
        ),
      ),
    );

    return expandido ? SizedBox(width: double.infinity, child: boton) : boton;
  }
}
