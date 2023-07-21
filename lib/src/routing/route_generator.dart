import 'package:get/get_navigation/get_navigation.dart';
import 'package:jgec_notice/src/features/core/screens/result/result.dart';
import '../features/authentication/screens/splash_screen/splash_screen.dart';
import '../features/authentication/screens/OTP/auth_otp.dart';
import '../features/authentication/screens/login/login_page.dart';
import '../features/authentication/screens/signup/signup_page.dart';
import '../features/core/screens/main_page/main_page.dart';

class RouteGenerator {
  static List<GetPage<dynamic>> getPagesRoute = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/signup', page: () => SignupPage()),
    GetPage(name: '/verify', page: () => const AuthPage()),
    GetPage(name: '/mainPage', page: () => const MainPage()),
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/resultByRoll', page: () => const ResultByRoll())
  ];
}
