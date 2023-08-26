import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeSmall extends ConsumerStatefulWidget {
  const NoticeSmall({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticeSmallState();
}

class _NoticeSmallState extends ConsumerState<NoticeSmall> {
  Future? loadNotices;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class NoticeDepartmental extends StatelessWidget {
//   const NoticeDepartmental({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Departmental Notices',
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineLarge
//                   ?.copyWith(color: Colors.black),
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               color: Colors.black,
//               onPressed: () {
//                 ProfileController.instance.saveDepartmentalNotice =
//                     ProfileController.instance.getDepartmentalNotice();
//               },
//             )
//           ],
//         ),
//         Obx(() {
//           if (ProfileController.instance.departmentalNotice.isEmpty) {
//             return Text(
//               'No Notices Found.',
//               style:
//                   Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
//             );
//           }
//           return SizedBox(
//             height: 400,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 // print(ProfileController.instance.departmentalNotice[index]);
//                 return Container(
//                   color: index % 2 == 0
//                       ? const Color.fromARGB(57, 0, 88, 147)
//                       : const Color.fromARGB(57, 0, 153, 255),
//                   child: ListTile(
//                     onTap: () {
//                       ProfileController.instance.openDepartmentalNotice(index);
//                     },
//                     title: Text(
//                       ProfileController.instance.departmentalNotice[index][0],
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(color: Colors.black),
//                     ),
//                     subtitle: Text(
//                       DateFormat.jm().add_yMMMd().format(ProfileController
//                           .instance.departmentalNotice[index][1]),
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ),
//                 );
//               },
//               itemCount: ProfileController.instance.departmentalNotice.length,
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
