import 'package:flutter/material.dart';

import '../../design/app_tokens.dart';

/// Botão principal: gradiente da marca, brilho ao passar o mouse e leve
/// afundada ao pressionar. Com [loading], mostra o indicador e não aceita
/// novo toque.
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hover = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
          onTap: _enabled ? widget.onPressed : null,
          child: AnimatedScale(
            scale: _pressed ? .97 : 1,
            duration: const Duration(milliseconds: 120),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: AppTokens.easeOut,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTokens.brandButton,
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppTokens.primary
                        .withValues(alpha: _hover && _enabled ? .55 : .30),
                    blurRadius: _hover && _enabled ? 28 : 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              foregroundDecoration: BoxDecoration(
                color: _enabled ? null : const Color(0x66000000),
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.loading
                    ? const SizedBox.square(
                        key: ValueKey('loading'),
                        dimension: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        key: const ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .2,
                            ),
                          ),
                          if (widget.icon != null) ...[
                            const SizedBox(width: 8),
                            AnimatedSlide(
                              offset: Offset(_hover ? .25 : 0, 0),
                              duration: const Duration(milliseconds: 200),
                              child: Icon(widget.icon,
                                  color: Colors.white, size: 18),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
