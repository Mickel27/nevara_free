import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import 'item_menu.dart';
import 'logo.dart';

/// Menú lateral de cualquier rol: logo, opciones y usuario abajo.
/// Se usa en vez de barra inferior porque la app es de computador.
class MenuLateral extends StatelessWidget {
  final List<ItemMenuData> items;
  final int seleccionado;
  final ValueChanged<int> onSeleccionar;
  final Usuario usuario;

  /// Texto bajo el nombre, por ejemplo "Administrador" o "Cajero · Sede Norte".
  final String descripcionUsuario;
  final VoidCallback onCerrarSesion;

  const MenuLateral({
    super.key,
    required this.items,
    required this.seleccionado,
    required this.onSeleccionar,
    required this.usuario,
    required this.descripcionUsuario,
    required this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Logo(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              'MENÚ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, i) => ItemMenu(
                icono: items[i].icono,
                texto: items[i].texto,
                activo: i == seleccionado,
                onTap: () => onSeleccionar(i),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    usuario.iniciales,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      Text(
                        descripcionUsuario,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar sesión',
                  icon: const Icon(Icons.logout, size: 18, color: AppColors.textSecondary),
                  onPressed: onCerrarSesion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
