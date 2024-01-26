import 'package:clickboard/src/core/constants/colors.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/utils.dart';
import '../../controllers/document_controller.dart';

class DocumentPage extends ConsumerWidget {
  final Document document;
  const DocumentPage({super.key, required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        ref
            .read(documentControllerProvider.notifier)
            .openDocument(context, document);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        // height: 10,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 37, 34),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.highlightColDdark, width: 0.1),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(255, 124, 177, 173),
                  blurRadius: 10,
                  spreadRadius: -5)
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
          child: Center(
              child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 21, 37, 34),
                    border: Border.all(
                        color: AppColors.highlightColDdark, width: 0.2),
                    borderRadius: BorderRadius.circular(25)),
                child: Icon(
                  Icons.edit_document,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                document.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateFormat.yMEd().format(document.timeCreated!),
                  '${formatBytes(document.size ?? 0, 2)}'
                ]
                    .map((e) => Text(
                          e,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
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
