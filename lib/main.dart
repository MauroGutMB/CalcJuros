import 'package:flutter/material.dart';

import 'historico_store.dart';
import 'paginas/inicio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoricoStore.instance.carregar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcJuros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PaginaInicio(),
    );
  }
}
