import 'package:flutter/material.dart';

import '../../../../core/common_widgets/fx/app_page.dart';
import '../../../../core/design/app_tokens.dart';

/// Grupo de opções da conta, num card com título.
class AccountSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AccountSection(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(title.toUpperCase(),
                style: const TextStyle(
                    color: AppTokens.textFaint,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4)),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: AppTokens.card,
              borderRadius: BorderRadius.circular(AppTokens.radiusMd + 4),
              border: Border.all(color: AppTokens.border),
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(
                        height: 1, indent: 64, color: AppTokens.border),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountListTile extends StatelessWidget {
  const AccountListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      this.subtitle,
      this.nextDisabled = false,
      required this.onPress,
      this.color});
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final bool nextDisabled;
  final VoidCallback onPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: onPress,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        hoverColor: const Color(0x0DFFFFFF),
        leading: IconBubble(
            icon: leadingIcon,
            color: color ?? const Color(0xFFC7C4FF),
            size: 38),
        title: Text(title,
            style: TextStyle(
                color: color ?? AppTokens.text,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!,
                style:
                    const TextStyle(color: AppTokens.textMuted, fontSize: 12.5)),
        trailing: nextDisabled
            ? null
            : const Icon(Icons.chevron_right_rounded,
                color: AppTokens.textFaint),
      ),
    );
  }
}

/// Foto do usuário ou, sem foto, as iniciais sobre o gradiente da marca.
class ProfileAvatar extends StatelessWidget {
  final String name;
  final Image? photo;
  final double size;

  const ProfileAvatar(
      {super.key, required this.name, this.photo, this.size = 56});

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTokens.brandButton,
        boxShadow: [
          BoxShadow(
              color: AppTokens.primary.withValues(alpha: .35), blurRadius: 18),
        ],
      ),
      child: ClipOval(
        child: photo != null
            ? SizedBox.expand(child: photo)
            : Container(
                color: AppTokens.surface,
                alignment: Alignment.center,
                child: Text(_initials,
                    style: TextStyle(
                        color: AppTokens.text,
                        fontSize: size * .34,
                        fontWeight: FontWeight.w800)),
              ),
      ),
    );
  }
}

/// Selo do perfil de acesso.
class RoleChip extends StatelessWidget {
  final bool isCoordinator;

  const RoleChip({super.key, required this.isCoordinator});

  @override
  Widget build(BuildContext context) {
    final color = isCoordinator ? const Color(0xFFFFB86B) : AppTokens.link;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isCoordinator ? Icons.shield_rounded : Icons.school_rounded,
              size: 13, color: color),
          const SizedBox(width: 5),
          Text(isCoordinator ? 'Coordenação' : 'Aluno',
              style: TextStyle(
                  color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
