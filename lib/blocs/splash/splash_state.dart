abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoginChecked extends SplashState {
  final bool isLoggedIn;
  SplashLoginChecked(this.isLoggedIn);
}

class SplashLoginError extends SplashState {
  final String message;
  SplashLoginError(this.message);
}