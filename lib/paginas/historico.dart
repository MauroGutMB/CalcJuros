import 'package:flutter/material.dart';

import '../formatadores.dart';
import '../historico_store.dart';
import '../models.dart';
import '../widgets/grafico_juros.dart';

class PaginaHistorico extends StatelessWidget {
  const PaginaHistorico({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HistoricoStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          ValueListenableBuilder<List<Juros>>(
            valueListenable: store.itens,
            builder: (context, itens, _) => IconButton(
              tooltip: 'Limpar histórico',
              icon: const Icon(Icons.delete_outline),
              onPressed: itens.isEmpty ? null : () => _confirmarLimpeza(context),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Juros>>(
        valueListenable: store.itens,
        builder: (context, itens, _) {
          if (itens.isEmpty) {
            return const Center(child: Text('Nenhum cálculo realizado ainda.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: itens.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _ItemHistorico(juros: itens[i]),
          );
        },
      ),
    );
  }

  Future<void> _confirmarLimpeza(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar histórico?'),
        content: const Text('Todos os cálculos salvos serão removidos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Limpar')),
        ],
      ),
    );
    if (ok == true) await HistoricoStore.instance.limpar();
  }
}

class _ItemHistorico extends StatelessWidget {
  final Juros juros;
  const _ItemHistorico({required this.juros});

  @override
  Widget build(BuildContext context) {
    final composto = juros.tipo == TipoJuros.composto;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Icon(composto ? Icons.trending_up : Icons.show_chart),
        title: Text('${juros.tipo.rotulo} • ${moeda(juros.montante!)}'),
        subtitle: Text(
          '${moeda(juros.capital)} a ${percentual(juros.taxa)} por ${juros.periodo} períodos\n'
          '${dataHora(juros.data)}',
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (juros.aplicacao > 0) Text('Aporte por período: ${moeda(juros.aplicacao)}'),
          Text('Total investido: ${moeda(juros.totalInvestido)}'),
          Text('Total em juros: ${moeda(juros.totalJuros)}'),
          const SizedBox(height: 16),
          GraficoJuros(juros: juros),
        ],
      ),
    );
  }
}
