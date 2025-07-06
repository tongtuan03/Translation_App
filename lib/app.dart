import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:translation_app/features/conversation/bloc/conversation_bloc.dart';
import 'package:translation_app/features/splash/bloc/splash_bloc.dart';
import 'package:translation_app/features/translation/bloc/translation_bloc.dart';
import 'package:translation_app/routes/router.dart';
import 'blocs/navigationbar/navigation_cubit.dart';
import 'data/services/firebase_services/auth_service.dart';
import 'features/history/bloc/history_bloc.dart';
import 'features/signin/bloc/signin_bloc.dart';
import 'features/signup/bloc/signup_bloc.dart';
import 'features/splash/bloc/splash_event.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SigninBloc(AuthService())),
        BlocProvider(create: (_) => SignupBloc(AuthService())),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => TranslationBloc()),
        BlocProvider(create: (_) => ConversationBloc()),
        BlocProvider(create: (_) => HistoryBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Translation App',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF6D1B7B,
            <int, Color>{
              50: Color(0xFFF3E6F4),
              100: Color(0xFFE1BFE4),
              200: Color(0xFFCE96D3),
              300: Color(0xFFBA6DC2),
              400: Color(0xFFAC4DB5),
              500: Color(0xFF6D1B7B), // main color
              600: Color(0xFF63186F),
              700: Color(0xFF56145F),
              800: Color(0xFF491150),
              900: Color(0xFF320B36),
            },
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6D1B7B),
            foregroundColor: Colors.black,
            elevation: 4,
          ),
        ),

        initialRoute: '/',
        routes: AppRouter.routes,
      ),
    );
  }
}