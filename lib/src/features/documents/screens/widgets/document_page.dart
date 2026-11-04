import 'package:clickboard/src/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common_widgets/fx/app_page.dart';
import '../../../../core/common_widgets/fx/hover_card.dart';
import '../../../../core/design/app_tokens.dart';
import '../../../../core/utils/utils.dart';
import '../../../../providers/utils_providers.dart';
import '../../controllers/document_controller.dart';

/// Ícone e cor de cada tipo de arquivo.
(IconData, Color) documentTypeStyle(String fileName) {
  switch (fileName.split('.').last.toLowerCase()) {
    case 'pdf':
      return (Icons.picture_as_pdf_rounded, const Color(0xFFFF7A85));
    case 'doc':
    case 'docx':
      return (Icons.description_rounded, const Color(0xFF7DB4FF));
    case 'ppt':
    case 'pptx':
      return (Icons.slideshow_rounded, const Color(0xFFFFB86B));
    case 'xls':
    case 'xlsx':
      return (Icons.table_chart_rounded, const Color(0xFF5EE0A0));
    case 'jpg':
    case 'jpeg':
    case 'png':
      return (Icons.image_rounded, const Color(0xFFD486E9));
    default:
      return (Icons.insert_drive_file_rounded, const Color(0xFFC7C4FF));
  }
}

class DocumentPage extends ConsumerStatefulWidget {
  final Document document;
  const DocumentPage({super.key, required this.document});

  @override
  ConsumerState<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  Future<void> openDocument() async {
    final result = await ref
        .read(documentControllerProvider.notifier)
        .openDocument(widget.document);
    if (!mounted) return;
    result.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (_) {});
  }

  Future<void> _showRenameDialog(
      BuildContext context, WidgetRef ref, Document document) async {
    TextEditingController renameController =
        TextEditingController(text: document.name);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Renomear documento'),
          content: TextField(
            controller: renameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Novo nome'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              child: const Text('Renomear'),
              onPressed: () {
                if (renameController.text.isNotEmpty) {
                  ref
                      .read(documentControllerProvider.notifier)
                      .renameDocument(document, newName: renameController.text)
                      .then((result) {
                    Navigator.of(dialogContext).pop();
                    context.pop();
                    result.fold(
                        (l) => showSnackBar(
                            context: context,
                            title: l,
                            snackBarType: SnackBarType.error), (r) {
                      showSnackBar(
                          context: context,
                          title: 'Documento renomeado',
                          snackBarType: SnackBarType.good);
                    });
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showProgress(BuildContext context, String label) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  /// Ações do documento. Baixar é para todos; renomear e excluir só para a
  /// coordenação (HU01) — o servidor também recusa (US-01).
  void _showActions() {
    HapticFeedback.mediumImpact();
    final bool isCoordinator =
        ref.read(myUserProvider)?.isCoordinator ?? false;
    final (icon, color) = documentTypeStyle(widget.document.name);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: IconBubble(icon: icon, color: color, size: 40),
                  title: Text(widget.document.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(formatBytes(widget.document.size ?? 0, 2),
                      style: const TextStyle(color: AppTokens.textMuted)),
                ),
                const Divider(height: 16),
                _ActionTile(
                  icon: Icons.download_rounded,
                  label: 'Baixar',
                  color: AppTokens.success,
                  onTap: () async {
                    _showProgress(context, 'Baixando...');
                    try {
                      await ref
                          .read(documentControllerProvider.notifier)
                          .downloadDocument(widget.document)
                          .then((path) {
                        context.pop();
                        path.fold(
                            (l) => showSnackBar(
                                context: context,
                                title: l,
                                snackBarType: SnackBarType.error), (r) {
                          showSnackBar(
                              context: context,
                              title: 'Arquivo salvo em $r',
                              snackBarType: SnackBarType.good);
                        });
                      });
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
                if (isCoordinator)
                  _ActionTile(
                    icon: Icons.drive_file_rename_outline_rounded,
                    label: 'Renomear',
                    color: AppTokens.link,
                    onTap: () {
                      _showRenameDialog(context, ref, widget.document);
                    },
                  ),
                if (isCoordinator)
                  _ActionTile(
                    icon: Icons.delete_outline_rounded,
                    label: 'Excluir',
                    color: AppTokens.danger,
                    onTap: () async {
                      _showProgress(context, 'Excluindo...');
                      try {
                        await ref
                            .read(documentControllerProvider.notifier)
                            .deleteDocument(widget.document)
                            .then((path) {
                          context.pop();
                          path.fold(
                              (l) => showSnackBar(
                                  context: context,
                                  title: l,
                                  snackBarType: SnackBarType.error), (r) {
                            showSnackBar(
                                context: context,
                                title: 'Documento excluído',
                                snackBarType: SnackBarType.good);
                          });
                        });
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = documentTypeStyle(widget.document.name);
    final created = widget.document.timeCreated;
    final extension = widget.document.name.contains('.')
        ? widget.document.name.split('.').last.toUpperCase()
        : 'ARQ';
    return HoverCard(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        openDocument();
      },
      onLongPress: _showActions,
      padding: const EdgeInsets.fromLTRB(16, 14, 6, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(icon: icon, color: color, size: 48),
              const Spacer(),
              IconButton(
                tooltip: 'Ações',
                onPressed: _showActions,
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppTokens.textMuted),
              ),
            ],
          ),
          const Spacer(),
          Text(
            widget.document.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppTokens.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(extension,
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .5)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    [
                      if (created != null)
                        DateFormat('dd/MM/yyyy').format(created),
                      formatBytes(widget.document.size ?? 0, 2),
                    ].join(' · '),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTokens.textMuted, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd)),
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
