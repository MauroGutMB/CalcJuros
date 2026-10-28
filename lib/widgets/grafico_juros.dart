import 'package:flutter/material.dart';

import '../formatadores.dart';
import '../models.dart';

/// Gráfico de linhas: montante acumulado x total investido por período.
class GraficoJuros extends StatelessWidget {
  final Juros juros;
  const GraficoJuros({super.key, required this.juros});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final montante = juros.serieMontante;
    final investido = juros.serieInvestido;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Evolução por período', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _Legenda(cor: cores.primary, texto: 'Montante'),
            _Legenda(cor: cores.outline, texto: 'Investido'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          width: double.infinity,
          child: CustomPaint(
            painter: _GraficoPainter(
              montante: montante,
              investido: investido,
              corMontante: cores.primary,
              corInvestido: cores.outline,
              corEixo: cores.outlineVariant,
              corTexto: cores.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _Legenda extends StatelessWidget {
  final Color cor;
  final String texto;
  const _Legenda({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}

class _GraficoPainter extends CustomPainter {
  final List<double> montante;
  final List<double> investido;
  final Color corMontante;
  final Color corInvestido;
  final Color corEixo;
  final Color corTexto;

  _GraficoPainter({
    required this.montante,
    required this.investido,
    required this.corMontante,
    required this.corInvestido,
    required this.corEixo,
    required this.corTexto,
  });

  static const _margemEsq = 64.0;
  static const _margemInf = 22.0;

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(
      _margemEsq,
      6,
      size.width - _margemEsq - 8,
      size.height - _margemInf - 6,
    );
    final pontos = montante.length;
    final maximo = montante.reduce((a, b) => a > b ? a : b);
    final topo = maximo <= 0 ? 1.0 : maximo;

    double x(int i) => area.left + (pontos <= 1 ? 0 : area.width * i / (pontos - 1));
    double y(double v) => area.bottom - area.height * (v / topo);

    // Grade horizontal e rótulos do eixo Y.
    final grade = Paint()
      ..color = corEixo
      ..strokeWidth = 1;
    for (var k = 0; k <= 4; k++) {
      final v = topo * k / 4;
      final py = y(v);
      canvas.drawLine(Offset(area.left, py), Offset(area.right, py), grade);
      _texto(canvas, _abreviar(v), Offset(area.left - 6, py), alinhaDireita: true);
    }

    // Rótulos do eixo X (primeiro, meio e último período).
    final ultimo = pontos - 1;
    for (final i in {0, ultimo ~/ 2, ultimo}) {
      _texto(canvas, '$i', Offset(x(i), area.bottom + 4), centralizaX: true);
    }

    _linha(canvas, investido, x, y, corInvestido);
    _linha(canvas, montante, x, y, corMontante, grossa: true);
  }

  void _linha(Canvas canvas, List<double> serie, double Function(int) x,
      double Function(double) y, Color cor, {bool grossa = false}) {
    final path = Path();
    for (var i = 0; i < serie.length; i++) {
      final p = Offset(x(i), y(serie[i]));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = cor
        ..style = PaintingStyle.stroke
        ..strokeWidth = grossa ? 3 : 2
        ..strokeJoin = StrokeJoin.round,
    );
    if (serie.length <= 1) {
      canvas.drawCircle(Offset(x(0), y(serie[0])), 4, Paint()..color = cor);
    }
  }

  void _texto(Canvas canvas, String texto, Offset pos,
      {bool alinhaDireita = false, bool centralizaX = false}) {
    final tp = TextPainter(
      text: TextSpan(text: texto, style: TextStyle(color: corTexto, fontSize: 11)),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = pos.dx;
    var dy = pos.dy;
    if (alinhaDireita) {
      dx -= tp.width;
      dy -= tp.height / 2;
    }
    if (centralizaX) dx -= tp.width / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  static String _abreviar(double v) {
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1).replaceAll('.', ',')} mi';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(1).replaceAll('.', ',')} mil';
    return v.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(_GraficoPainter old) =>
      old.montante != montante || old.investido != investido || old.corMontante != corMontante;
}

/// Resumo textual usado junto do gráfico.
class ResumoJuros extends StatelessWidget {
  final Juros juros;
  const ResumoJuros({super.key, required this.juros});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Montante final', style: tema.titleMedium),
        Text(moeda(juros.montante!), key: const Key('montante'), style: tema.headlineMedium),
        const Divider(height: 24),
        Text('Total investido: ${moeda(juros.totalInvestido)}'),
        Text('Total em juros: ${moeda(juros.totalJuros)}'),
      ],
    );
  }
}
