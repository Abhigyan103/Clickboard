import 'package:flutter/material.dart';

import '../../design/app_tokens.dart';
import 'gradient_text.dart';
import 'reveal_in.dart';

/// Largura máxima do conteúdo das abas: no desktop o conteúdo não estica
/// até as bordas.
const double appContentMaxWidth = 980;

/// Cabeçalho das abas do app: sobretítulo, título com destaque em gradiente
/// e uma ação opcional à direita.
class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? highlight;
  final String? subtitle;
  final Widget? action;

  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.highlight,
    this.subtitle,
    this.action,
  });

  static const _titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    height: 1.1,
    color: AppTokens.text,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RevealIn(
                  child: Text(
                    eyebrow.toUpperCase(),
                    style: const TextStyle(
                      color: AppTokens.primarySoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RevealIn(
                  delay: const Duration(milliseconds: 80),
                  child: Wrap(
                    children: [
                      Text(title, style: _titleStyle),
                      if (highlight != null)
                        GradientText(' $highlight', style: _titleStyle),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  RevealIn(
                    delay: const Duration(milliseconds: 160),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                          color: AppTokens.textMuted,
                          fontSize: 14,
                          height: 1.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 12),
            RevealIn(delay: const Duration(milliseconds: 200), child: action!),
          ],
        ],
      ),
    );
  }
}

/// Centraliza e limita a largura de um sliver de conteúdo.
class SliverContent extends StatelessWidget {
  final Widget sliver;

  const SliverContent({super.key, required this.sliver});

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(builder: (context, constraints) {
      final extra =
          (constraints.crossAxisExtent - appContentMaxWidth).clamp(0.0, double.infinity) / 2;
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: extra),
        sliver: sliver,
      );
    });
  }
}

/// Ícone dentro de uma bolha com o gradiente suave da marca.
class IconBubble extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBubble({
    super.key,
    required this.icon,
    this.color = const Color(0xFFC7C4FF),
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .3),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .26), color.withValues(alpha: .10)],
        ),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

/// Estado vazio ilustrado: ícone grande, título e explicação.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          IconBubble(icon: icon, size: 72),
          const SizedBox(height: 18),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTokens.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTokens.textMuted, fontSize: 13.5, height: 1.5)),
        ],
      ),
    );
  }
}

/// Lista de cartões "fantasma" pulsando enquanto o conteúdo carrega.
class SkeletonList extends StatefulWidget {
  final int count;
  final double height;

  const SkeletonList({super.key, this.count = 4, this.height = 76});

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.of(context).disableAnimations && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: .45, end: 1).animate(_controller),
      child: Column(
        children: [
          for (var i = 0; i < widget.count; i++)
            Container(
              height: widget.height,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(AppTokens.radiusMd + 4),
                border: Border.all(color: AppTokens.border),
              ),
            ),
        ],
      ),
    );
  }
}
