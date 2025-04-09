part of 'phone_number_verification_cubit.dart';

class PhoneNumberVerificationState extends Equatable {
  final bool isLoading;
  final int? resendToken;
  final String? phoneNumber;
  final String? verificationId;
  final PhoneVerificationStatus? status;

  const PhoneNumberVerificationState({
    this.status,
    this.resendToken,
    this.phoneNumber,
    this.verificationId,
    this.isLoading = false,
  });

  @override
  @override
  List<Object?> get props => [
    isLoading,
    resendToken,
    phoneNumber,
    verificationId,
    status,
  ];

  PhoneNumberVerificationState resetForResend() {
    return PhoneNumberVerificationState(phoneNumber: phoneNumber);
  }

  PhoneNumberVerificationState completed() {
    return const PhoneNumberVerificationState(
      status: StatusOtpVerificationComplete(),
    );
  }

  PhoneNumberVerificationState copyWith({
    bool? isLoading,
    int? resendToken,
    String? phoneNumber,
    String? verificationId,
    PhoneVerificationStatus? status,
  }) {
    return PhoneNumberVerificationState(
      isLoading: isLoading ?? this.isLoading,
      resendToken: resendToken ?? this.resendToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      status: status ?? this.status,
    );
  }

  PhoneNumberVerificationState error(PhoneVerificationStatus status) {
    return PhoneNumberVerificationState(
      status: status,
      phoneNumber: phoneNumber,
      resendToken: resendToken,
      verificationId: verificationId,
    );
  }

  PhoneNumberVerificationState loading() {
    return PhoneNumberVerificationState(
      status: status,
      isLoading: true,
      phoneNumber: phoneNumber,
      resendToken: resendToken,
      verificationId: verificationId,
    );
  }

  PhoneNumberVerificationState otpCodeSent(StatusOtpCodeSent status) {
    return PhoneNumberVerificationState(
      status: status,
      phoneNumber: status.phoneNumber,
      resendToken: status.resendToken,
      verificationId: status.verificationId,
    );
  }
}
