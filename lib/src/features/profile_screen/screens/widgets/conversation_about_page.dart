import 'package:clickboard/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AssistantText extends StatelessWidget {
  const AssistantText({
    super.key,
    required this.text,
    this.height = 80,
    this.width = 300,
  });

  final String text;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        // height: height,
        width: width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
          color: AppColors.assistBoxColDark,
        ),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserText extends StatelessWidget {
  const UserText({
    super.key,
    required this.text,
    this.height = 80,
    this.width = 300,
  });

  final String text;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        // height: height,
        width: width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24)),
          color: AppColors.userBoxColDark,
        ),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
          ),
        ),
      ),
    );
  }
}
