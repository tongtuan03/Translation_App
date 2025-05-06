import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/splash/bloc/splash_bloc.dart';
import 'package:translation_app/features/splash/bloc/splash_event.dart';
import 'package:translation_app/features/splash/bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashCheckLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoginChecked) {
            if (state.isLoggedIn) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/signin');
            }
          }
        },
        child: const Center(child: CircularProgressIndicator()),
    );
  }
}
