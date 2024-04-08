import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// List<DropdownMenuEntry<String>> semDropdownList =
//     List<int>.generate(8, (index) => index + 1)
//         .map((e) => DropdownMenuEntry(
//               value: e.toString(),
//               label: e.toString(),
//             ))
//         .toList();

enum SnackBarType {
  good(backgroundColor: Colors.green),
  error(backgroundColor: Color(0xFFCF6679));

  const SnackBarType({required this.backgroundColor});
  final Color backgroundColor;
}

showSnackBar(
    {required BuildContext context,
    required String title,
    required SnackBarType snackBarType}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      backgroundColor: snackBarType.backgroundColor,
    ));
}

Future<T?> showMyAdaptiveDialog<T>({required BuildContext context, Widget? title, Widget? content, List<Widget>? actions}){
  return showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
                  actionsPadding: EdgeInsets.fromLTRB(0, 0, 15, 10),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  shape: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                      title: title,
                      content: content,
                      actions: actions,
            ));
}

Future<OpenResult?> openFile(String filePath) async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    return OpenFile.open(filePath);
  }
  return null;
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
  } finally {}
  return directory?.path;
}

List<String> departments = ['CE', 'EE', 'ME', 'CSE', 'ECE', 'IT'];

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
