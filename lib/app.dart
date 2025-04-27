import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/routes/router.dart';
import 'package:translation_app/screens/signin_screen.dart';
import 'package:translation_app/screens/welcome_screen.dart';
import 'package:translation_app/share_preferences/login_preferences.dart';

import 'blocs/signin/signin_bloc.dart';
import 'blocs/signup/signup_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StateLogin>(
      future: LoginPreference.getLogin(),
      builder: (context, snapshot) {
          final isSignedIn = snapshot.data == StateLogin.loggedIn;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SigninBloc()),
              BlocProvider(create: (_) => SignupBloc()),
            ],
            child: MaterialApp(
              title: 'Translation App',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: isSignedIn ? '/' : '/welcome',
              routes: AppRouter.routes,
            ),
          );
      },
    );
  }
}
