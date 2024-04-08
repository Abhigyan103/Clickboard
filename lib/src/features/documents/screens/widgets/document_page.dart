import 'package:clickboard/src/core/constants/colors.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/utils/utils.dart';
import '../../controllers/document_controller.dart';

class DocumentPage extends ConsumerStatefulWidget {
  final Document document;
  const DocumentPage({super.key, required this.document});

  @override
  ConsumerState<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  openDocument() async {
    var file = await ref
        .read(documentControllerProvider.notifier)
        .saveDocumentFile(widget.document);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }

  Future<void> _showRenameDialog(
      BuildContext context, WidgetRef ref, Document document) async {
    TextEditingController renameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text('Rename Document'),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(
                hintText: 'Enter new name',
                hintStyle: TextStyle(color: Colors.white30)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
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
                          title: 'File renamed',
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

  Icon _getIconForDocumentType(String fileType) {
    switch (fileType.toLowerCase()) {
      case '.pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case '.doc':
      case '.docx':
        return const Icon(Icons.description, color: Colors.blue);
      case '.ppt':
      case '.pptx':
        return const Icon(Icons.slideshow, color: Colors.orange);
      case '.xls':
      case '.xlsx':
        return const Icon(Icons.table_chart, color: Colors.blueAccent);
      case '.text':
        return const Icon(Icons.notes, color: Colors.blueGrey);
      case '.jpg':
      case '.jpeg':
      case '.png':
        return const Icon(Icons.image, color: Colors.purple);
      default:
        return const Icon(Icons.document_scanner_rounded, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon documentIcon =
        _getIconForDocumentType(".${widget.document.name.split('.').last}");

    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        openDocument();
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        iconColor: Colors.greenAccent,
                        textColor: Colors.greenAccent,
                        splashColor: Colors.blueGrey,
                        title: const Text('Download'),
                        trailing: const Icon(Icons.download_rounded),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return const Dialog(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text(
                                        "Downloading...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
                                    title: 'File saved in $r',
                                    snackBarType: SnackBarType.good);
                              });
                            });
                          } finally {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Divider(),
                      ListTile(
                        iconColor: Colors.blueAccent,
                        textColor: Colors.blueAccent,
                        splashColor: Colors.blueGrey,
                        trailing:
                            const Icon(Icons.drive_file_rename_outline_rounded),
                        title: const Text('Rename'),
                        onTap: () {
                          _showRenameDialog(context, ref, widget.document);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        iconColor: Colors.redAccent,
                        splashColor: Colors.blueGrey,
                        textColor: Colors.redAccent,
                        title: const Text('Delete'),
                        trailing: const Icon(Icons.delete_forever_rounded),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return const Dialog(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text(
                                        "Deleting...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
                                    title: 'File deleted',
                                    snackBarType: SnackBarType.good);
                              });
                            });
                            
                          }finally {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        // height: 10,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 34, 58),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.highlightColDdark, width: 0.1),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 124, 177, 173),
                blurRadius: 10,
                spreadRadius: -5)
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/Document.jpg'),
            opacity: 0.2,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
          child: Center(
              child: Column(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 37, 34),
                      border: Border.all(
                          color: AppColors.highlightColDdark, width: 0.2),
                      borderRadius: BorderRadius.circular(25)),
                  child: documentIcon),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.document.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 15),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateFormat.yMEd().format(widget.document.timeCreated!),
                  (formatBytes(widget.document.size ?? 0, 2))
                ]
                    .map((e) => Text(
                          e,
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ))
                    .toList(),
              )
            ],
          )),
        ),
      ),
    );
  }
}
