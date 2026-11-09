/// $27400 -> "$27.400" (RNF-02).
String formatearPesos(num valor) {
  final texto = valor.round().toString();
  final conPuntos = texto.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => '.',
  );
  return '\$$conPuntos';
}

String _dosDigitos(int n) => n.toString().padLeft(2, '0');

/// 25/10/2026 · 11:58
String formatearFechaHora(DateTime f) =>
    '${_dosDigitos(f.day)}/${_dosDigitos(f.month)}/${f.year} · ${_dosDigitos(f.hour)}:${_dosDigitos(f.minute)}';

/// 11:58
String formatearHora(DateTime f) => '${_dosDigitos(f.hour)}:${_dosDigitos(f.minute)}';

bool mismoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
