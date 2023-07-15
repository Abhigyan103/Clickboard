import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/large_button.dart';
import '../../../../../constants/image_strings.dart';
import '../../../controllers/student_controller.dart';

class ProfileSmall extends StatelessWidget {
  const ProfileSmall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var studentController = Get.find<StudentController>();
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
          studentController.student.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          studentController.student.email,
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
