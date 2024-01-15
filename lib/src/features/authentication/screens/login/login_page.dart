import 'package:clickboard/src/core/common_widgets/large_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/image_strings.dart';
import 'widgets/login_form.dart';
import 'widgets/login_text.dart';
import 'widgets/signup_option.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // SizedBox.square(
              //   dimension: 300,
              //   child: SvgPicture.asset(loginSVG),
              // ),
              SizedBox.square(
                  dimension: 300, child: LottieBuilder.asset(loginLottie)),
              const LoginText(),
              const LoginForm(),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 15.0, right: 10.0,top: 26),
                          child: Divider(
                            color:  Color(0xff176B80),
                            height: 30.0,
                            thickness: 2.0,
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 26),
                      child: Text("OR",
                        style: TextStyle(
                            color:  Color(0xff176B87),
                            fontSize:22),
                      ),
                    ),

                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 15.0,top: 26),
                          child: Divider(
                            color: Color(0xff176B87),
                            height: 30.0,
                            thickness: 2.0,
                          )),
                    ),
                  ]
              ),
              SizedBox(height: 35 ),
              MainButton(
                  onPressed: (){
                    signInWithGoogle();
                  },
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(

                            child: Image.network('http://pngimg.com/uploads/google/google_PNG19635.png')
                        ),

                        Text('Sign-In with Google',style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        )
                        )
                      ]
                  )
              ),

              TextButton(
                  onPressed: () {
                    GoRouter.of(context).push('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
            ],
          ),
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
    );

  }
  signInWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);  //verifies that this is working


  }


}
