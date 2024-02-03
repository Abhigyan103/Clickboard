import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Navbaritems extends StatelessWidget {
  final String animationAsset;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double animationWidth;
  final double animationHeight;
  final Color activeColor;
  final Color inactiveColor;

  const Navbaritems({super.key,required this.animationAsset,
  required this.text,
  required this.isSelected,
  required this.onTap,
    this.animationWidth = 24.0,
    this.animationHeight = 24.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  } );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      ColorFiltered(
      colorFilter: ColorFilter.mode(
        isSelected ? activeColor : inactiveColor,
        BlendMode.srcIn,
      ),
      child: Lottie.asset(
        animationAsset,
        width: animationWidth,
        height: animationHeight,
      ),
    ),
    Text(
    text,
    style: TextStyle(
      fontSize:15,
    color: isSelected ? activeColor : inactiveColor,

    ),
    ),
    ],
    ),
    );
  }
}