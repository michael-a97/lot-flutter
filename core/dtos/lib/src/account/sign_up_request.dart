import 'package:equatable/equatable.dart';

class SignUpRequestDto extends Equatable {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;

  const SignUpRequestDto({
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, firstName, lastName, password];
}
