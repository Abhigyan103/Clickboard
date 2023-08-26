// import 'package:flutter/material.dart';

// class DocumentsPage extends StatefulWidget {
//   const DocumentsPage({super.key});

//   @override
//   State<DocumentsPage> createState() => _DocumentsPageState();
// }

// class _DocumentsPageState extends State<DocumentsPage> {
//   late List<String> pdfName;
//   late List<String> pdfLink;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: ListView.separated(
//         itemBuilder: (context, index) => SmallCard(
//           text: 'Doc $index',
//           contCol: Theme.of(context).colorScheme.primaryContainer,
//           onContCol: Theme.of(context).colorScheme.onPrimaryContainer,
//         ),
//         itemCount: 20,
//         separatorBuilder: (BuildContext context, int index) => const Divider(),
//       ),
//     );
//   }
// }
