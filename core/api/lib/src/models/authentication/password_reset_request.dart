part of 'authentication.dart';

@JsonSerializable(createFactory: false)
class PasswordResetRequest extends Equatable {
  final String phoneNumber;
  final String newPassword;
  @JsonKey(includeToJson: false)
  final String phoneNumberVerificationToken;

  const PasswordResetRequest({
    required this.phoneNumber,
    required this.newPassword,
    required this.phoneNumberVerificationToken,
  });

  Json toJson() => _$PasswordResetRequestToJson(this);

  @override
  List<Object> get props => [
    phoneNumber,
    newPassword,
    phoneNumberVerificationToken,
  ];
}
