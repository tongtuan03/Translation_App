import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/blocs/navigation/navigation_bloc.dart';
import 'package:translation_app/blocs/splash/splash_bloc.dart';
import 'package:translation_app/routes/router.dart';
import 'blocs/signin/signin_bloc.dart';
import 'blocs/signup/signup_bloc.dart';
import 'blocs/splash/splash_event.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SigninBloc()),
          BlocProvider(create: (_) => SignupBloc()),
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider(create: (_) => SplashBloc()..add(SplashCheckLoginStatus())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Translation App',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/home',
          routes: AppRouter.routes,
        ));
  }
}
