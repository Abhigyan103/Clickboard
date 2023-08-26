import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSmall extends ConsumerWidget {
  const ProfileSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

// class ProfileSmall extends StatelessWidget {
//   const ProfileSmall({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var profileController = Get.find<ProfileController>();
//     Student? student = profileController.student;
//     return Column(
//       children: [
//         SizedBox(
//           width: 125,
//           height: 125,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(100),
//             child: const Image(image: AssetImage(profileImage)),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Text(
//           student!.name,
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         Text(
//           student.email,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         MainButton(
//           onPressed: () {},
//           text: 'Edit Profile',
//         ),
//       ],
//     );
//   }
// }
