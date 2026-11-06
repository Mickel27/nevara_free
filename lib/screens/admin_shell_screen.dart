import 'package:flutter/material.dart';
import '../model/user_session.dart';
import '../state/app_state.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/notification_banner.dart';
import 'component_gallery_screen.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'sales_history_screen.dart';

class AdminShellScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const AdminShellScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _currentTitle {
    switch (_currentTab) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Gestión de inventario';
      case 2:
        return 'Historial de ventas';
      case 3:
        return 'Galería de componentes';
      default:
        return 'NevaraFresh';
    }
  }

  String get _currentSubtitle {
    switch (_currentTab) {
      case 0:
        return 'Resumen general de la cadena';
      case 1:
        return 'Stock independiente por tienda';
      case 2:
        return 'Transacciones registradas en todas las tiendas';
      case 3:
        return 'Sistema de diseño y especificaciones visuales';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final session = widget.appState.currentUser ?? UserSession.adminDemo;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: AppSidebar(
              user: session,
              selectedIndex: _currentTab,
              onItemSelected: (idx) {
                setState(() => _currentTab = idx);
                Navigator.of(context).pop();
              },
              onLogout: widget.onLogout,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;

              return Stack(
                children: [
                  Row(
                    children: [
                      if (isDesktop)
                        AppSidebar(
                          user: session,
                          selectedIndex: _currentTab,
                          onItemSelected: (idx) => setState(() => _currentTab = idx),
                          onLogout: widget.onLogout,
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            AppTopBar(
                              title: _currentTitle,
                              subtitle: _currentSubtitle,
                              selectedStore: widget.appState.selectedStore,
                              onStoreChanged: (store) {
                                if (store != null) widget.appState.setSelectedStore(store);
                              },
                              onOpenDrawer: !isDesktop
                                  ? () => _scaffoldKey.currentState?.openDrawer()
                                  : null,
                            ),
                            Expanded(
                              child: IndexedStack(
                                index: _currentTab,
                                children: [
                                  DashboardScreen(
                                    appState: widget.appState,
                                    onNavigateToInventory: () => setState(() => _currentTab = 1),
                                  ),
                                  InventoryScreen(
                                    appState: widget.appState,
                                  ),
                                  SalesHistoryScreen(
                                    appState: widget.appState,
                                  ),
                                  const ComponentGalleryScreen(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Floating bottom toast notification
                  if (widget.appState.activeNotification != null)
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: NotificationBanner(
                        notification: widget.appState.activeNotification!,
                        onDismiss: widget.appState.dismissNotification,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
