import 'dart:math';

enum TipoJuros {
  simples('Juros simples'),
  composto('Juros compostos');

  final String rotulo;
  const TipoJuros(this.rotulo);
}

class Juros {
  final TipoJuros tipo;
  final double capital;
  final double aplicacao;
  final double taxa;
  final int periodo;
  final DateTime data;
  double? montante;

  Juros({
    required this.capital,
    required this.aplicacao,
    required this.taxa,
    required this.periodo,
    this.tipo = TipoJuros.composto,
    DateTime? data,
  }) : data = data ?? DateTime.now();

  /// Montante após [n] períodos, com aporte [aplicacao] ao fim de cada período.
  ///
  /// Composto: M = C(1+i)^n + A((1+i)^n - 1)/i
  /// Simples:  M = C(1+i·n) + A·n + i·A·n(n-1)/2
  double montanteEm(int n) {
    final i = taxa / 100;
    switch (tipo) {
      case TipoJuros.composto:
        final fator = pow(1 + i, n).toDouble();
        final aportes = i == 0 ? aplicacao * n : aplicacao * (fator - 1) / i;
        return capital * fator + aportes;
      case TipoJuros.simples:
        return capital * (1 + i * n) + aplicacao * n + i * aplicacao * n * (n - 1) / 2;
    }
  }

  double calcularMontante() => montante = montanteEm(periodo);

  double investidoEm(int n) => capital + aplicacao * n;

  double get totalInvestido => investidoEm(periodo);

  double get totalJuros => (montante ?? calcularMontante()) - totalInvestido;

  /// Montante em cada período, de 0 até [periodo].
  List<double> get serieMontante => [for (var n = 0; n <= periodo; n++) montanteEm(n)];

  /// Total investido em cada período, de 0 até [periodo].
  List<double> get serieInvestido => [for (var n = 0; n <= periodo; n++) investidoEm(n)];

  Map<String, dynamic> toJson() => {
        'tipo': tipo.name,
        'capital': capital,
        'aplicacao': aplicacao,
        'taxa': taxa,
        'periodo': periodo,
        'data': data.toIso8601String(),
      };

  factory Juros.fromJson(Map<String, dynamic> json) => Juros(
        tipo: TipoJuros.values.byName(json['tipo'] as String),
        capital: (json['capital'] as num).toDouble(),
        aplicacao: (json['aplicacao'] as num).toDouble(),
        taxa: (json['taxa'] as num).toDouble(),
        periodo: json['periodo'] as int,
        data: DateTime.parse(json['data'] as String),
      )..calcularMontante();
}
