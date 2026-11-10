import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/app_tokens.dart';

/// Fundo da marca: manchas de luz índigo e violeta que orbitam devagar, sobre
/// uma malha de pontos que some nas bordas.
///
/// Com "reduzir movimento" ligado, as manchas ficam paradas.
class AuroraBackground extends StatefulWidget {
  final Widget child;

  const AuroraBackground({super.key, required this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(seconds: 26));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
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
    return ColoredBox(
      color: AppTokens.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _AuroraPainter(
                        Curves.easeInOut.transform(_controller.value)),
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(child: CustomPaint(painter: _DotGrid())),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;

  const _AuroraPainter(this.t);

  void _blob(Canvas canvas, Offset center, double radius, Color color) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
          .createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final vmax = math.max(size.width, size.height);
    final drift = Offset(-.06 * vmax * t, .05 * vmax * t);

    _blob(
      canvas,
      Offset(size.width + .04 * vmax, -.02 * vmax) + drift,
      .46 * vmax * (1 + .1 * t),
      AppTokens.primary.withValues(alpha: .36),
    );
    _blob(
      canvas,
      Offset(size.width * .55, size.height + .02 * vmax) - drift,
      .40 * vmax,
      AppTokens.violet.withValues(alpha: .25),
    );
    _blob(
      canvas,
      Offset(-.05 * vmax, size.height * .35) + drift * .5,
      .28 * vmax,
      const Color(0xFF3B82F6).withValues(alpha: .12),
    );
  }

  @override
  bool shouldRepaint(_AuroraPainter old) => old.t != t;
}

/// Malha de pontos, mais forte no centro e sumindo nas bordas.
class _DotGrid extends CustomPainter {
  const _DotGrid();

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 22.0;
    final center = Offset(size.width * .55, size.height * .45);
    final maxDist = size.shortestSide * .9;
    final paint = Paint();
    for (var x = gap / 2; x < size.width; x += gap) {
      for (var y = gap / 2; y < size.height; y += gap) {
        final d = (Offset(x, y) - center).distance / maxDist;
        final alpha = (1 - d).clamp(0.0, 1.0) * .22;
        if (alpha < .01) continue;
        paint.color = const Color(0xFF8B87FF).withValues(alpha: alpha);
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGrid old) => false;
}
