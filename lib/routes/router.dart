import 'package:flutter/cupertino.dart';
import 'package:translation_app/screens/welcome_screen.dart';

import '../screens/home_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/signin': (context) => const SignInScreen(),
    '/signup': (context) => const SignUpScreen(),
  };
}