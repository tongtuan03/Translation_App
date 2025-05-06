import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:translation_app/features/splash/bloc/splash_bloc.dart';
import 'package:translation_app/routes/router.dart';
import 'blocs/navigationbar/navigation_cubit.dart';
import 'features/signin/bloc/signin_bloc.dart';
import 'features/signup/bloc/signup_bloc.dart';
import 'features/splash/bloc/splash_event.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SigninBloc()),
          BlocProvider(create: (_) => SignupBloc()),
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(create: (_) => ChatBloc()),
          BlocProvider(create: (_) => SplashBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Translation App',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/',
          routes: AppRouter.routes,
        ));
  }
}
