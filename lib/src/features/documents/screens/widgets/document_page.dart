import 'package:clickboard/src/core/constants/colors.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/utils.dart';
import '../../controllers/document_controller.dart';

class DocumentPage extends ConsumerWidget {
  final Document document;
  const DocumentPage({super.key, required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        ref
            .read(documentControllerProvider.notifier)
            .openDocument(context, document);
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
                        onTap: () {
                          ref
                              .read(documentControllerProvider.notifier)
                              .downloadDocument(document)
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
                          ref
                              .read(documentControllerProvider.notifier)
                              .renameDocument(document, newName: 'ABCDEF')
                              .then((path) {
                            context.pop();
                            path.fold(
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
                          ref
                              .read(documentControllerProvider.notifier)
                              .deleteDocument(document)
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
                child: const Icon(
                  Icons.edit_document,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                document.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 15),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateFormat.yMEd().format(document.timeCreated!),
                  (formatBytes(document.size ?? 0, 2))
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
