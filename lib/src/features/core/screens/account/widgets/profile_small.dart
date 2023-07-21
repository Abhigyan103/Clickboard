import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/authentication/models/student_model.dart';
import 'package:jgec_notice/src/features/core/controllers/profile_controller.dart';

import '../../../../../common_widgets/large_button.dart';
import '../../../../../constants/image_strings.dart';

class ProfileSmall extends StatelessWidget {
  const ProfileSmall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var profileController = Get.find<ProfileController>();
    Student? student = profileController.student;
    return Column(
      children: [
        SizedBox(
          width: 125,
          height: 125,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(image: AssetImage(profileImage)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          student!.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          student.email,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 10,
        ),
        MainButton(
          onPressed: () {},
          text: 'Edit Profile',
        ),
      ],
    );
  }
}
