import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translation_app/features/signin/bloc/signin_event.dart';
import 'package:translation_app/features/signin/bloc/signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SigninBloc() : super(SigninInitial()) {
    on<SigninSubmitted>(_onSigninSubmitted);
  }

  Future<void> _onSigninSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(SigninLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(SigninSuccess());
    } catch (e) {
      emit(SigninFailure(e.toString()));
    }
  }
}
