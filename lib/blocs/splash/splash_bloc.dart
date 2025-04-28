import 'package:bloc/bloc.dart';
import 'package:translation_app/blocs/splash/splash_event.dart';
import 'package:translation_app/blocs/splash/splash_state.dart';

import '../../share_preferences/login_preferences.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashCheckLoginStatus>((event, emit) async {
      final loginState = await LoginPreference.getLogin();
      bool isLoggedIn = loginState == StateLogin.loggedIn;
      await Future.delayed(const Duration(seconds: 2));
      emit(SplashLoginChecked(isLoggedIn));
    });
  }
}
