enum UserRole {
  admin,
  cashier,
}

class UserSession {
  final String name;
  final String email;
  final UserRole role;
  final String roleTitle;
  final String store;
  final String initials;

  const UserSession({
    required this.name,
    required this.email,
    required this.role,
    required this.roleTitle,
    required this.store,
    required this.initials,
  });

  static const UserSession adminDemo = UserSession(
    name: 'Laura Gómez',
    email: 'laura.gomez@nevarafresh.com',
    role: UserRole.admin,
    roleTitle: 'Administrador',
    store: 'Todas las tiendas',
    initials: 'LG',
  );

  static const UserSession cashierDemo = UserSession(
    name: 'Carlos Ruiz',
    email: 'carlos.ruiz@nevarafresh.com',
    role: UserRole.cashier,
    roleTitle: 'Cajero · Sede Norte',
    store: 'Sede Norte · Cali',
    initials: 'CR',
  );
}
