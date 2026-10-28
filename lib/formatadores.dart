String moeda(double v) {
  final negativo = v < 0;
  final partes = v.abs().toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '${negativo ? '-' : ''}R\$ $inteiro,${partes[1]}';
}

String percentual(double v) =>
    '${v.toStringAsFixed(2).replaceAll('.', ',')}%';

String dataHora(DateTime d) {
  String dois(int n) => n.toString().padLeft(2, '0');
  return '${dois(d.day)}/${dois(d.month)}/${d.year} ${dois(d.hour)}:${dois(d.minute)}';
}
