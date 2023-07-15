import 'package:get/get_navigation/get_navigation.dart';
import 'package:jgec_notice/src/features/authentication/screens/splash_screen/splash_screen.dart';
import '../features/authentication/screens/OTP/auth_otp.dart';
import '../features/authentication/screens/login/login_page.dart';
import '../features/authentication/screens/signup/sign_up.dart';
import '../features/core/screens/main_page/main_page.dart';
import '../features/core/screens/account/widgets/settings.dart';

class RouteGenerator {
  static List<GetPage<dynamic>> getPagesRoute = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/signup', page: () => SignUpPage()),
    GetPage(name: '/verify', page: () => const AuthPage()),
    GetPage(name: '/mainPage', page: () => const MainPage()),
    GetPage(name: '/settings', page: () => const Settings()),
    GetPage(name: '/splash', page: () => SplashScreen()),
  ];
}
