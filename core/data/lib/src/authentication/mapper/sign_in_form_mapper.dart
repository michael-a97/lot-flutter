import 'package:api/api.dart' as api;
import 'package:dtos/dtos.dart' as dtos;

extension SignInFormMapper on dtos.SignInFormDto {
  api.SignInRequest toApi() {
    return api.SignInRequest(phoneNumber: phoneNumber, password: password);
  }
}
