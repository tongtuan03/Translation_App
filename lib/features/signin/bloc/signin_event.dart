import 'package:equatable/equatable.dart';

abstract class SigninEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

class SigninSubmitted extends SigninEvent {
  final String email;
  final String password;

  SigninSubmitted(this.email, this.password);

}
