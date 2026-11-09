import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

const _dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
const _meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];

/// "Domingo, 25 oct 2026"
String fechaLarga(DateTime f) => '${_dias[f.weekday - 1]}, ${f.day} ${_meses[f.month - 1]} ${f.year}';

/// Encabezado de cada sección: título, subtítulo, selector de tienda y fecha.
class BarraSuperior extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget? selectorTienda;
  final DateTime fecha;

  const BarraSuperior({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.fecha,
    this.selectorTienda,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitulo, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (selectorTienda != null) ...[
            selectorTienda!,
            const SizedBox(width: 12),
          ],
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(fechaLarga(fecha), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
