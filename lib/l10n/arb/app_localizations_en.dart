// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lot.';

  @override
  String get signUp => 'Sign Up';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String nameError(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'empty': 'This field is required',
      'tooShort': 'Please enter a valid name',
      'other': 'Invalid input.',
    });
    return '$_temp0';
  }

  @override
  String passwordError(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'empty': 'This field is required',
      'tooShort': 'Your password is too short',
      'weak':
          'The password you entered is weak it should contain Capital letters, a Digit, and a Special Character (@\$!%*?&)',
      'other': 'Invalid input.',
    });
    return '$_temp0 ';
  }

  @override
  String confirmPasswordError(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'empty': 'This field is required',
      'doNotMatch':
          'The confirmation password you entered doesn\'t match with the first password',
      'other': 'Invalid input. ',
    });
    return '$_temp0';
  }

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get searchByCountryName => 'Search by country name';

  @override
  String get verify => 'Verify';

  @override
  String get resendVerificationMessage =>
      'Didn\'t receive a verification code?';

  @override
  String get resend => 'Resend';

  @override
  String get verifyPhoneNumber => 'Verify phone number';

  @override
  String timeoutCountDownMessage(String duration) {
    return 'Didn\'t receive a code? we can resend it in $duration';
  }

  @override
  String enterVerificationCode(String phoneNumber) {
    return 'Enter the six digit code sent to $phoneNumber';
  }

  @override
  String get serverErrorTryAgainLater =>
      'Server Error. Please try again later.';

  @override
  String networkErrorMessage(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'cancelled': 'Request cancelled.',
      'connection': 'Please check your internet connection and try again.',
      'custom': 'Something went wrong. Try again.',
      'format': 'Something went wrong. Try again.',
      'server': 'Server error. Try again later.',
      'timeout': 'Connection timeout. Please check your internet connection.',
      'unhandled': 'Something went wrong.',
      'other': 'Something went wrong. Try again.',
    });
    return '$_temp0';
  }

  @override
  String get otpVerificationSuccessful => 'Successfully verified phone number';

  @override
  String otpVerificationErrorMessage(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'invalidOtp': 'Please enter a valid OTP code.',
      'otpExpired': 'OTP code expired. Try again.',
      'invalidPhoneNumber': 'Please enter a valid phone number.',
      'tooManyRequests': 'Too many requests. Try again later.',
      'timedOut': 'OTP verification Timed out. Please try again',
      'unknown': 'Something went wrong. Please try again',
      'other': 'Invalid input.',
    });
    return '$_temp0';
  }

  @override
  String get phoneNumberValidationError => 'Please enter a valid phone number';

  @override
  String get phoneNumberVerificationFailed =>
      'Phone number verification failed';

  @override
  String get phoneNumberVerificationTimedOut =>
      'Phone number verification timed out';

  @override
  String get signUpSuccessful => 'Successfully created an account';

  @override
  String get otpErrorText => 'Enter a valid 6 digit code';

  @override
  String get signIn => 'Sign in';

  @override
  String signInPasswordError(String error) {
    String _temp0 = intl.Intl.selectLogic(error, {
      'empty': 'This field is required',
      'invalid': 'Please enter a valid password',
      'other': 'Invalid input.',
    });
    return '$_temp0';
  }

  @override
  String get createAccountSignInScreenPrompt => 'Don\'t have an account yet?';

  @override
  String get now => 'now';

  @override
  String get signInScreenSubTitle => 'Enter your phone number and password';

  @override
  String get enterAValidPhoneNumber => 'Please enter a valid phone number.';

  @override
  String get fillFormToCreateAccount =>
      'Fill the form below to create your account';

  @override
  String get forgotPasswordPrompt => 'Forgot password?';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get newPassword => 'New password';

  @override
  String get forgotPasswordSubheading =>
      'Verify your phone number to reset your password and set a new one.';

  @override
  String get successfullyResetPassword => 'Successfully reset password';
}
