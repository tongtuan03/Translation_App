import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;
  final String username;

  SignupSubmitted(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}