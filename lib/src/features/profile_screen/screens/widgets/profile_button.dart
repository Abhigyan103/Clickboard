import 'package:flutter/material.dart';

import '../../../../core/common_widgets/fx/app_page.dart';
import '../../../../core/design/app_tokens.dart';

/// Botão redondo com rótulo, usado na escolha da foto de perfil.
class ProfileButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final IconData icon;
  const ProfileButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            IconBubble(icon: icon, size: 56),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: AppTokens.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
