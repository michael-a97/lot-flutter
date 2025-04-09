part of 'authentication.dart';

enum OtpVerificationError {
  invalidOtp,
  timedOut,
  otpExpired,
  tooManyRequests,
  invalidPhoneNumber,
  unknown;

  factory OtpVerificationError.fromFirebase(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return OtpVerificationError.invalidOtp;
      case 'invalid-verification-id':
        return OtpVerificationError.otpExpired;
      case 'invalid-phone-number':
        return OtpVerificationError.invalidPhoneNumber;
      case 'too-many-requests':
        return OtpVerificationError.tooManyRequests;
      default:
        return OtpVerificationError.unknown;
    }
  }
}
