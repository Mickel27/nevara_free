import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import 'boton_nf.dart';

/// Modal "Reponer existencias" (F-06).
/// Es Stateful solo por el controller del campo (estado de interfaz).
/// Devuelve las unidades con `Navigator.pop(context, unidades)`;
/// la Screen lo abre con `await showDialog<int>(...)`.
class ReponerForm extends StatefulWidget {
  final Producto producto;
  final Inventario inventario;
  final String nombreTienda;

  const ReponerForm({
    super.key,
    required this.producto,
    required this.inventario,
    required this.nombreTienda,
  });

  @override
  State<ReponerForm> createState() => _ReponerFormState();
}

class _ReponerFormState extends State<ReponerForm> {
  final _unidadesCtrl = TextEditingController();
  int _unidades = 0;

  @override
  void dispose() {
    _unidadesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inv = widget.inventario;
    final quedaria = inv.existencias + _unidades;

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
                  const Expanded(
                    child: Text('Reponer existencias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Las unidades se sumarán al stock disponible de ${widget.producto.nombre} en '
                '${widget.nombreTienda}. El stock de las demás tiendas no cambia.',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Stock actual', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const Spacer(),
                        Text('${inv.existencias} und. (mín. ${inv.minimo})', style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Unidades a reponer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 90,
                          height: 38,
                          child: TextField(
                            controller: _unidadesCtrl,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: '0',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (texto) => setState(() => _unidades = int.tryParse(texto) ?? 0),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$quedaria und.',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    texto: 'Registrar reposición',
                    // Regla F-06: entero mayor que 0; si no, deshabilitado (CA-3).
                    onPressed: _unidades > 0 ? () => Navigator.pop(context, _unidades) : null,
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
