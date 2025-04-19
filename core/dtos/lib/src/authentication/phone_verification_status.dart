part of 'authentication.dart';

abstract class PhoneVerificationStatus extends Equatable {
  const PhoneVerificationStatus();

  @override
  List<Object?> get props => [];
}

class StatusOtpCodeSent extends PhoneVerificationStatus {
  final int? resendToken;
  final String phoneNumber;
  final String verificationId;

  const StatusOtpCodeSent({
    this.resendToken,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  List<Object?> get props => [resendToken, phoneNumber, verificationId];
}

class StatusOtpVerificationComplete extends PhoneVerificationStatus {
  const StatusOtpVerificationComplete();
}

class StatusOtpVerificationFailed extends PhoneVerificationStatus {
  final OtpVerificationError error;

  const StatusOtpVerificationFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class StatusOtpRequestTimedOut extends PhoneVerificationStatus {
  final String verificationId;

  const StatusOtpRequestTimedOut(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}
