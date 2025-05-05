import 'package:flutter/cupertino.dart';
import 'package:translation_app/features/splash/view/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/signin/view/signin_screen.dart';
import '../features/signup/view/signup_screen.dart';
import '../features/welcome/welcome_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) =>  SplashScreen(),
    '/home': (context) =>  HomeScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/signin': (context) => const SignInScreen(),
    '/signup': (context) => const SignUpScreen(),
  };
}