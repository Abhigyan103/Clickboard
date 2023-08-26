import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

List<DropdownMenuItem<String>> semDropdownList =
    List<int>.generate(8, (index) => index + 1)
        .map((e) => DropdownMenuItem(
              value: e.toString(),
              child: Text(e.toString()),
            ))
        .toList();

showSnackBar(
    {required BuildContext context,
    required String title,
    Color color = Colors.green}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(title),
      backgroundColor: color,
    ));
}

Future<OpenResult?> openFile(String filePath) async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    return OpenFile.open(filePath);
  }
  return null;
}

List<String> departments = ['CE', 'EE', 'ME', 'CSE', 'ECE', 'IT'];
