import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common_widgets/fx/app_page.dart';
import '../../../../core/common_widgets/fx/hover_card.dart';
import '../../../../core/design/app_tokens.dart';
import '../../../../core/utils/utils.dart';
import '../../../../models/notice_model.dart';
import '../../controllers/notice_controller.dart';

class NoticeTile extends ConsumerStatefulWidget {
  const NoticeTile({super.key, required this.notice});

  final Notice notice;

  @override
  ConsumerState<NoticeTile> createState() => _NoticeTileState();
}

class _NoticeTileState extends ConsumerState<NoticeTile> {
  Future<void> openNotice() async {
    final result = await ref
        .read(noticeControllerProvider.notifier)
        .openNotice(widget.notice);
    if (!mounted) return;
    result.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (_) {});
  }

  Future<void> downloadNotice() async {
    var path = await ref
        .read(noticeControllerProvider.notifier)
        .downloadNotice(widget.notice);
    if (!mounted) return;
    path.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) => showSnackBar(
            context: context,
            title: 'Arquivo salvo em $r',
            snackBarType: SnackBarType.good));
  }

  @override
  Widget build(BuildContext context) {
    final created = widget.notice.timeCreated;
    final isNew =
        created != null && DateTime.now().difference(created).inDays < 3;
    return HoverCard(
      onTap: openNotice,
      child: Row(
        children: [
          const IconBubble(icon: Icons.campaign_rounded),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notice.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppTokens.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 13, color: AppTokens.textFaint),
                    const SizedBox(width: 4),
                    Text(
                      created == null
                          ? 'Sem data'
                          : DateFormat('dd/MM/yyyy').format(created),
                      style: const TextStyle(
                          color: AppTokens.textMuted, fontSize: 12),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      const _NewBadge(),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Baixar',
            onPressed: downloadNotice,
            icon: const Icon(Icons.download_rounded,
                color: AppTokens.textMuted),
          ),
        ],
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: AppTokens.brandButton,
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Text('NOVO',
          style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: .6)),
    );
  }
}
