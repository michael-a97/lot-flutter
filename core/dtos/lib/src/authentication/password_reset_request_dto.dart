part of 'authentication.dart';

class PasswordResetRequestDto extends Equatable {
  final String phoneNumber;
  final String newPassword;

  const PasswordResetRequestDto({
    required this.phoneNumber,
    required this.newPassword,
  });

  @override
  List<Object> get props => [phoneNumber, newPassword];
}
