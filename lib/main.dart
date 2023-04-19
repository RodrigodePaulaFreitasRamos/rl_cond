// Autor: Rodrigo de Paula Freitas Ramos
// Data de Criação: 19 de abril de 2023
// Descrição: Arquivo principal de entrada para a aplicação RL_COND

import 'package:flutter/material.dart';
import 'package:rl_cond/services/bloco_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BlocoService _blocoService = BlocoService(); // Instancie o serviço de blocos

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicação RL_COND',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final BlocoService _blocoService = BlocoService(); // Instancie o serviço de blocos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _fetchBlocos(); // Chame o método para buscar blocos
          },
          child: Text('Buscar Blocos'),
        ),
      ),
    );
  }

  void _fetchBlocos() async {
    try {
      final List<Bloco> blocos = await _blocoService.getBlocos(); // Chame o método para buscar blocos
      // Faça algo com a lista de blocos obtidos, como atualizar a UI
    } catch (e) {
      // Trate possíveis erros, como mostrar uma mensagem de erro na UI
      print('Falha ao buscar blocos: $e');
    }
  }
}
