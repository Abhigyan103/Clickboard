// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../../core/constants/image_strings.dart';
// import '../../../../core/constants/text_strings.dart';
// import '../OTP/widgets/resend_code.dart';
// import 'widgets/rounded_pin.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var textTheme = Theme.of(context).textTheme;
//     InputController inputController = Get.find();
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               otpSVG,
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.width * 0.9,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(otpTitle, style: textTheme.titleLarge),
//                       Text(
//                         '$otpSubtitle ${inputController.phone.value.text}',
//                         style: textTheme.titleSmall,
//                       ),
//                     ],
//                   )),
//                   SizedBox.square(
//                       dimension: 90, child: Image.asset(collegeLogo)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),
//             const RoundedWithShadow(),
//             const SizedBox(height: 20),
//             const ResendCodePrompt()
//           ],
//         ),
//       ),
//     );
//   }
// }
