import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultSmall extends ConsumerStatefulWidget {
  const ResultSmall({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultSmallState();
}

class _ResultSmallState extends ConsumerState<ResultSmall> {
  Future? loadResults;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class ResultSmall extends StatefulWidget {
//   const ResultSmall({super.key});

//   @override
//   State<ResultSmall> createState() => _ResultSmallState();
// }

// class _ResultSmallState extends State<ResultSmall> {
//   Future? semesters;

//   @override
//   void initState() {
//     super.initState();
//     semesters = ProfileController.instance.getSemesters();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Results',
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineLarge
//                   ?.copyWith(color: Colors.black),
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               color: Colors.black,
//               onPressed: () {
//                 setState(() {
//                   semesters = ProfileController.instance.getSemesters();
//                 });
//               },
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         FutureBuilder(
//           future: semesters,
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.none:
//                 return Text(
//                   'No connection',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall!
//                       .copyWith(fontSize: 15),
//                 );
//               case ConnectionState.waiting:
//               case ConnectionState.active:
//                 return Text(
//                   'Fetching results...',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall!
//                       .copyWith(fontSize: 15),
//                 );
//               case ConnectionState.done:
//                 return Obx(() {
//                   List<bool> data = ProfileController.instance.semesters;
//                   if (!data.contains(true)) {
//                     return Text(
//                       'No Results Found.',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .copyWith(fontSize: 15),
//                     );
//                   }
//                   return SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 50,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (data[index]) {
//                           return Row(
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 3.5,
//                                 child: FilledButton(
//                                   onPressed: () => ProfileController.instance
//                                       .openResult(index),
//                                   child: Text('Sem ${index + 1}'),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               )
//                             ],
//                           );
//                         } else {
//                           return const SizedBox();
//                         }
//                       },
//                       itemCount: data.length,
//                     ),
//                   );
//                 });
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
