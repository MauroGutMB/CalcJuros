import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Histórico de cálculos, persistido localmente.
class HistoricoStore {
  HistoricoStore._();
  static final instance = HistoricoStore._();

  static const _chave = 'historico';
  static const _limite = 50;

  final ValueNotifier<List<Juros>> itens = ValueNotifier(const []);

  Future<void> carregar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bruto = prefs.getStringList(_chave) ?? const [];
      itens.value = [
        for (final s in bruto) Juros.fromJson(jsonDecode(s) as Map<String, dynamic>),
      ];
    } catch (_) {
      itens.value = const [];
    }
  }

  Future<void> adicionar(Juros juros) async {
    itens.value = [juros, ...itens.value].take(_limite).toList();
    await _salvar();
  }

  Future<void> limpar() async {
    itens.value = const [];
    await _salvar();
  }

  Future<void> _salvar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _chave,
        [for (final j in itens.value) jsonEncode(j.toJson())],
      );
    } catch (_) {
      // Sem persistência o histórico continua funcionando em memória.
    }
  }
}
