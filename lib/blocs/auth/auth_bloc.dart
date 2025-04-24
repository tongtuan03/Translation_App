// auth_bloc.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLoginEvent) {
      yield AuthLoadingState();
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        yield AuthSuccessState(message: 'Đăng nhập thành công!');
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    }

    if (event is AuthSignupEvent) {
      yield AuthLoadingState();
      try {
        await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        yield AuthSuccessState(message: 'Đăng ký thành công!');
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    }
  }
}
