import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translation_app/features/signup/bloc/signup_event.dart';
import 'package:translation_app/features/signup/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
