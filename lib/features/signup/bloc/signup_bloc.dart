import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/signup/bloc/signup_event.dart';
import 'package:translation_app/features/signup/bloc/signup_state.dart';
import 'package:translation_app/data/services/firebase_services/auth_service.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService;

  SignupBloc(this._authService) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event,
      Emitter<SignupState> emit,
      ) async {
    emit(SignupLoading());
    try {
      await _authService.signUp(event.email, event.password, event.username);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}