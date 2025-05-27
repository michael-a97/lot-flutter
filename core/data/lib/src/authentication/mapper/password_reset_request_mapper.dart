import 'package:api/api.dart' as api;
import 'package:dtos/dtos.dart' as dtos;

extension PasswordResetRequestMapper on dtos.PasswordResetRequestDto {
  api.PasswordResetRequest toApi({
    required String phoneNumberVerificationToken,
  }) {
    return api.PasswordResetRequest(
      phoneNumber: phoneNumber,
      newPassword: newPassword,
      phoneNumberVerificationToken: phoneNumberVerificationToken,
    );
  }
}
