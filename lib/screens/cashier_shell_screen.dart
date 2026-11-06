import 'package:flutter/material.dart';
import '../model/user_session.dart';
import '../state/app_state.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/notification_banner.dart';
import 'inventory_screen.dart';
import 'pos_screen.dart';
import 'sales_history_screen.dart';

class CashierShellScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const CashierShellScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  State<CashierShellScreen> createState() => _CashierShellScreenState();
}

class _CashierShellScreenState extends State<CashierShellScreen> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _currentTitle {
    switch (_currentTab) {
      case 0:
        return 'Punto de venta';
      case 1:
        return 'Stock de mi tienda';
      case 2:
        return 'Mis ventas';
      default:
        return 'NevaraFresh';
    }
  }

  String get _currentSubtitle {
    switch (_currentTab) {
      case 0:
        return 'Caja 2 · Sede Norte · Cali';
      case 1:
        return 'Inventario disponible en Sede Norte';
      case 2:
        return 'Transacciones registradas por Carlos Ruiz';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final session = widget.appState.currentUser ?? UserSession.cashierDemo;

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
                              selectedStore: 'Sede Norte · Cali',
                              storeOptions: const ['Sede Norte · Cali'],
                              onOpenDrawer: !isDesktop
                                  ? () => _scaffoldKey.currentState?.openDrawer()
                                  : null,
                            ),
                            Expanded(
                              child: IndexedStack(
                                index: _currentTab,
                                children: [
                                  PosScreen(appState: widget.appState),
                                  InventoryScreen(appState: widget.appState),
                                  SalesHistoryScreen(
                                    appState: widget.appState,
                                    cashierFilter: 'Carlos Ruiz',
                                  ),
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
                      left: 24,
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
