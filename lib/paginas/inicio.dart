import 'package:flutter/material.dart';

import 'calcular.dart';
import 'como_funciona.dart';
import 'historico.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => pagina));
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final tema = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: LogoCalcJuros(tamanho: 112)),
                  const SizedBox(height: 16),
                  Text('CalcJuros',
                      textAlign: TextAlign.center,
                      style: tema.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: cores.primary)),
                  const SizedBox(height: 4),
                  Text('Simule juros simples e compostos',
                      textAlign: TextAlign.center, style: tema.bodyMedium),
                  const SizedBox(height: 40),
                  FilledButton.icon(
                    style: _estilo,
                    onPressed: () => _abrir(context, const PaginaCalcular()),
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    style: _estilo,
                    onPressed: () => _abrir(context, const PaginaHistorico()),
                    icon: const Icon(Icons.history),
                    label: const Text('Histórico'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: _estilo,
                    onPressed: () => _abrir(context, const PaginaComoFunciona()),
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Como funciona'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static final _estilo = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
    textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 16)),
  );
}

/// Logo do app: círculo com símbolo de moeda e seta de crescimento.
class LogoCalcJuros extends StatelessWidget {
  final double tamanho;
  const LogoCalcJuros({super.key, this.tamanho = 96});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cores.primary, cores.tertiary],
        ),
        boxShadow: [
          BoxShadow(
            color: cores.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.attach_money, size: tamanho * 0.55, color: cores.onPrimary),
          Positioned(
            right: tamanho * 0.12,
            top: tamanho * 0.12,
            child: Icon(Icons.trending_up, size: tamanho * 0.26, color: cores.onPrimary),
          ),
        ],
      ),
    );
  }
}
