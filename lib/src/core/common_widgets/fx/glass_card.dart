import 'package:flutter/material.dart';

import '../../design/app_tokens.dart';

/// Card escuro com borda fina, brilho no topo e sombra profunda.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 30, 28, 24),
    this.radius = AppTokens.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTokens.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppTokens.border),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000), blurRadius: 60, offset: Offset(0, 30)),
          BoxShadow(
              color: Color(0x146366F1), blurRadius: 80, spreadRadius: -10),
        ],
      ),
      child: Stack(
        children: [
          // Reflexo de 1px na borda de cima, como vidro.
          Positioned(
            top: 0,
            left: radius,
            right: radius,
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0x00FFFFFF),
                  Color(0x33FFFFFF),
                  Color(0x00FFFFFF),
                ]),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
