part of 'authentication.dart';

class SignInFormDto extends Equatable {
  final String phoneNumber;
  final String password;

  const SignInFormDto({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}
