import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/utils_providers.dart';
import '../design/app_tokens.dart';

/// Abas do app, na ordem de [AppScreen].
const appTabs = [
  (Icons.campaign_outlined, Icons.campaign_rounded, 'Avisos'),
  (Icons.folder_outlined, Icons.folder_rounded, 'Documentos'),
  (Icons.assignment_outlined, Icons.assignment_rounded, 'Notas'),
  (Icons.person_outline_rounded, Icons.person_rounded, 'Conta'),
];

/// Barra de navegação flutuante em vidro fosco. A aba ativa abre uma pílula
/// com o gradiente da marca e o nome da aba.
class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navigationIndexProvider);
    final photo = ref.watch(myPhotoProvider);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xCC13131A),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppTokens.border),
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < appTabs.length; i++)
                        Expanded(
                          flex: i == selected ? 3 : 2,
                          child: _NavItem(
                            icon: appTabs[i].$1,
                            activeIcon: appTabs[i].$2,
                            label: appTabs[i].$3,
                            active: i == selected,
                            avatar: i == appTabs.length - 1 ? photo : null,
                            onTap: () => ref
                                .read(navigationIndexProvider.notifier)
                                .update(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool active;
  final Image? avatar;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget glyph = avatar != null
        ? ClipOval(child: SizedBox.square(dimension: 22, child: avatar))
        : Icon(active ? activeIcon : icon,
            size: 22, color: active ? Colors.white : AppTokens.textMuted);
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: AppTokens.easeOut,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: active ? AppTokens.brandButton : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppTokens.primary.withValues(alpha: .4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              glyph,
              Flexible(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 320),
                  curve: AppTokens.easeOut,
                  child: active
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
