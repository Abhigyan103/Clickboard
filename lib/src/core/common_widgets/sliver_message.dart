import 'package:flutter/material.dart';

import '../design/app_tokens.dart';
import 'fx/app_page.dart';

/// Mensagem de erro para usar dentro de uma lista de slivers
/// (`CustomScrollView`). Um `Center` solto ali quebra a tela inteira.
class SliverMessage extends StatelessWidget {
  final String text;

  const SliverMessage(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          children: [
            const IconBubble(
                icon: Icons.cloud_off_rounded,
                color: AppTokens.danger,
                size: 64),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTokens.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Puxe a tela para baixo para tentar de novo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTokens.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
