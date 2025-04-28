import 'package:flutter/cupertino.dart';
import 'package:translation_app/screens/splash/splash_screen.dart';
import 'package:translation_app/screens/welcome/welcome_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/signin/signin_screen.dart';
import '../screens/signup/signup_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) =>  SplashScreen(),
    '/home': (context) =>  HomeScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/signin': (context) => const SignInScreen(),
    '/signup': (context) => const SignUpScreen(),
  };
}