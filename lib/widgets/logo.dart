import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Marca NevaraFresh: ícono verde + nombre.
class Logo extends StatelessWidget {
  final double tamano;

  /// En fondo verde (login) el texto va en blanco.
  final bool claro;

  const Logo({super.key, this.tamano = 32, this.claro = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: tamano,
          height: tamano,
          decoration: BoxDecoration(
            color: claro ? Colors.white : AppColors.primary,
            borderRadius: BorderRadius.circular(tamano / 4),
          ),
          child: Icon(
            Icons.eco_rounded,
            size: tamano * 0.6,
            color: claro ? AppColors.primary : Colors.white,
          ),
        ),
        SizedBox(width: tamano / 3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Nevara',
                style: TextStyle(color: claro ? Colors.white : AppColors.textPrimary),
              ),
              TextSpan(
                text: 'Fresh',
                style: TextStyle(color: claro ? Colors.white : AppColors.primary),
              ),
            ],
          ),
          style: TextStyle(fontSize: tamano * 0.56, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        ),
      ],
    );
  }
}
