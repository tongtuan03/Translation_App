import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/splash/splash_bloc.dart';
import '../../blocs/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashLoginChecked) {
          if (state.isLoggedIn) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, '/welcome');
          }
        } else if (state is SplashLoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Hiển thị một spinner trong khi chờ
        ),
      ),
    );
  }
}
