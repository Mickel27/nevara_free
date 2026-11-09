import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'boton_nf.dart';

/// Base de los modales: título, descripción, contenido y Cancelar / Confirmar.
/// Cancelar y la X cierran sin valor. Confirmar cierra con `true`,
/// así la Screen hace: `final ok = await showDialog<bool>(...)`.
class ModalNF extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final Widget? contenido;
  final String textoConfirmar;
  final bool peligro;

  const ModalNF({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.textoConfirmar,
    this.contenido,
    this.peligro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(descripcion, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              if (contenido != null) ...[
                const SizedBox(height: 16),
                contenido!,
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BotonNF(
                    texto: 'Cancelar',
                    variante: VariacionBoton.secundario,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  BotonNF(
                    texto: textoConfirmar,
                    variante: peligro ? VariacionBoton.peligro : VariacionBoton.principal,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Caja gris de resumen dentro de un modal (por ejemplo, "Total a pagar").
class ResumenModal extends StatelessWidget {
  final String etiquetaArriba;
  final String valorArriba;
  final String etiquetaAbajo;
  final String valorAbajo;

  const ResumenModal({
    super.key,
    required this.etiquetaArriba,
    required this.valorArriba,
    required this.etiquetaAbajo,
    required this.valorAbajo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Text(etiquetaArriba, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const Spacer(),
              Text(valorArriba, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(etiquetaAbajo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                valorAbajo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
