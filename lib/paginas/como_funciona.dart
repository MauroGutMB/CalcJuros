import 'package:flutter/material.dart';

class PaginaComoFunciona extends StatelessWidget {
  const PaginaComoFunciona({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Como funciona')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Secao(
            icone: Icons.show_chart,
            titulo: 'Juros simples',
            texto: 'Os juros incidem sempre sobre o capital inicial, então crescem '
                'de forma linear.',
            formula: 'M = C · (1 + i · n)',
          ),
          _Secao(
            icone: Icons.trending_up,
            titulo: 'Juros compostos',
            texto: 'Os juros de cada período são somados ao capital e passam a render '
                'também ("juros sobre juros"), então crescem de forma exponencial.',
            formula: 'M = C · (1 + i)ⁿ',
          ),
          _Secao(
            icone: Icons.savings_outlined,
            titulo: 'Aporte por período',
            texto: 'Se você informar um aporte, ele é depositado ao fim de cada período '
                'e passa a render a partir do período seguinte.',
            formula: 'Composto: M = C·(1+i)ⁿ + A·((1+i)ⁿ − 1) / i\n'
                'Simples: M = C·(1+i·n) + A·n + i·A·n·(n−1)/2',
          ),
          _Secao(
            icone: Icons.help_outline,
            titulo: 'Legenda',
            texto: 'M = montante final\n'
                'C = capital inicial\n'
                'A = aporte por período\n'
                'i = taxa por período, em decimal (5% → 0,05)\n'
                'n = número de períodos\n\n'
                'A taxa e o período devem usar a mesma unidade, por exemplo '
                '1% ao mês por 12 meses.',
          ),
          _Secao(
            icone: Icons.insights,
            titulo: 'Gráfico',
            texto: 'A linha de montante mostra quanto você terá ao fim de cada período. '
                'A linha de investido mostra só o que saiu do seu bolso. A distância '
                'entre as duas é o total ganho em juros.',
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String texto;
  final String? formula;

  const _Secao({
    required this.icone,
    required this.titulo,
    required this.texto,
    this.formula,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: tema.colorScheme.primary),
                const SizedBox(width: 8),
                Text(titulo, style: tema.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(texto),
            if (formula != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tema.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formula!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
