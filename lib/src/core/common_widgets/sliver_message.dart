import 'package:flutter/material.dart';

/// Mensagem centralizada para usar dentro de uma lista de slivers
/// (`CustomScrollView`). Um `Center` solto ali quebra a tela inteira.
class SliverMessage extends StatelessWidget {
  final String text;

  const SliverMessage(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(text, textAlign: TextAlign.center)),
      ),
    );
  }
}
