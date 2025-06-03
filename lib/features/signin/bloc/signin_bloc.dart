import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/signin/bloc/signin_event.dart';
import 'package:translation_app/features/signin/bloc/signin_state.dart';
import 'package:translation_app/data/services/firebase_services/auth_service.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthService _authService;

  SigninBloc(this._authService) : super(SigninInitial()) {
    on<SigninSubmitted>(_onSigninSubmitted);
  }

  Future<void> _onSigninSubmitted(
      SigninSubmitted event,
      Emitter<SigninState> emit,
      ) async {
    emit(SigninLoading());
    try {
      await _authService.signIn(event.email, event.password);
      emit(SigninSuccess());
    } catch (e) {
      emit(SigninFailure(e.toString()));
    }
  }
}