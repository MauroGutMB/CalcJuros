import 'dart:math';

class Juros {
  final double capital;
  final double aplicacao;
  final double taxa;
  final int periodo;
  double? montante;

  Juros({
    required this.capital,
    required this.aplicacao,
    required this.taxa,
    required this.periodo,
  });

  double calcularMontante() {
    montante = capital * pow((1 + taxa / 100), periodo) + aplicacao;
    return montante!;
  }

}

