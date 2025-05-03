import 'dart:async';

import 'package:api/api.dart';
import 'package:dartz/dartz.dart';
import 'package:dtos/dtos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:session_storage/session_storage.dart';

import '../../../data.dart';

part 'authentication_repository_impl.dart';

/// A repository responsible for authenticating a user.
abstract class AuthenticationRepository {
  /// Requests an OTP to be sent to the given [phoneNumber].
  ///
  /// If a [resendToken] is provided, the OTP will be resent to the given
  /// [phoneNumber].
  Stream<PhoneVerificationStatus> requestPhoneVerification(
    String phoneNumber, [
    int? resendToken,
  ]);

  /// Verifies the given [otp] using the given [verificationId].
  Future<Either<StatusOtpVerificationFailed, Unit>> verifyPhoneOtp(
    String otp,
    String verificationId,
  );

  /// Signs in the user with the given [request].
  Future<NetworkResponse<SignInResponseDto>> signIn(SignInFormDto request);

  /// Deletes stored user session.
  Future<void> signOut();

  Future<bool> isUserAuthenticated();
}

/// The maximum amount of time you are willing to wait for SMS auto-retrieval to
/// be completed.
const resendOtpRequestTimeoutDuration = Duration(minutes: 1);
