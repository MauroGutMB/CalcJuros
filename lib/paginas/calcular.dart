import 'package:flutter/material.dart';

import '../historico_store.dart';
import '../models.dart';
import '../widgets/grafico_juros.dart';

class PaginaCalcular extends StatefulWidget {
  const PaginaCalcular({super.key});

  @override
  State<PaginaCalcular> createState() => _PaginaCalcularState();
}

class _PaginaCalcularState extends State<PaginaCalcular> {
  final _formKey = GlobalKey<FormState>();
  final _capitalCtrl = TextEditingController();
  final _aplicacaoCtrl = TextEditingController();
  final _taxaCtrl = TextEditingController();
  final _periodoCtrl = TextEditingController();
  TipoJuros _tipo = TipoJuros.composto;
  Juros? _resultado;

  @override
  void dispose() {
    _capitalCtrl.dispose();
    _aplicacaoCtrl.dispose();
    _taxaCtrl.dispose();
    _periodoCtrl.dispose();
    super.dispose();
  }

  double? _numero(String texto) => double.tryParse(texto.trim().replaceAll(',', '.'));

  String? _validarNumero(String? v, {bool permiteVazio = false}) {
    if (v == null || v.trim().isEmpty) return permiteVazio ? null : 'Campo obrigatório';
    final n = _numero(v);
    if (n == null) return 'Número inválido';
    if (n < 0) return 'Não pode ser negativo';
    return null;
  }

  String? _validarPeriodo(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    final n = int.tryParse(v.trim());
    if (n == null) return 'Informe um número inteiro';
    if (n <= 0) return 'Deve ser maior que zero';
    if (n > 1200) return 'Máximo de 1200 períodos';
    return null;
  }

  void _calcular() {
    if (!_formKey.currentState!.validate()) return;
    final juros = Juros(
      tipo: _tipo,
      capital: _numero(_capitalCtrl.text)!,
      aplicacao: _numero(_aplicacaoCtrl.text) ?? 0,
      taxa: _numero(_taxaCtrl.text)!,
      periodo: int.parse(_periodoCtrl.text.trim()),
    )..calcularMontante();
    HistoricoStore.instance.adicionar(juros);
    setState(() => _resultado = juros);
  }

  void _limpar() {
    _formKey.currentState!.reset();
    for (final c in [_capitalCtrl, _aplicacaoCtrl, _taxaCtrl, _periodoCtrl]) {
      c.clear();
    }
    setState(() => _resultado = null);
  }

  Widget _campo(
    TextEditingController ctrl,
    String rotulo,
    String? Function(String?) validador, {
    bool inteiro = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        validator: validador,
        keyboardType: TextInputType.numberWithOptions(decimal: !inteiro),
        decoration: InputDecoration(labelText: rotulo, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = _resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<TipoJuros>(
                    segments: [
                      for (final t in TipoJuros.values)
                        ButtonSegment(value: t, label: Text(t.rotulo)),
                    ],
                    selected: {_tipo},
                    onSelectionChanged: (s) => setState(() {
                      _tipo = s.first;
                      _resultado = null;
                    }),
                  ),
                  const SizedBox(height: 20),
                  _campo(_capitalCtrl, 'Capital inicial (R\$)', _validarNumero),
                  _campo(
                    _aplicacaoCtrl,
                    'Aporte por período (R\$) — opcional',
                    (v) => _validarNumero(v, permiteVazio: true),
                  ),
                  _campo(_taxaCtrl, 'Taxa de juros por período (%)', _validarNumero),
                  _campo(_periodoCtrl, 'Período (nº de meses/períodos)', _validarPeriodo,
                      inteiro: true),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(onPressed: _calcular, child: const Text('Calcular')),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(onPressed: _limpar, child: const Text('Limpar')),
                    ],
                  ),
                  if (r != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ResumoJuros(juros: r),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GraficoJuros(juros: r),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
