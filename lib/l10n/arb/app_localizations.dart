import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lot.'**
  String get appName;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'{error, select, empty {This field is required} tooShort {Please enter a valid name} other {Invalid input.}}'**
  String nameError(String error);

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'{error, select, empty {This field is required} tooShort {Your password is too short} weak {The password you entered is weak it should contain Capital letters, a Digit, and a Special Character (@\$!%*?&)}  other {Invalid input.}} '**
  String passwordError(String error);

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'{error, select, empty {This field is required} doNotMatch {The confirmation password you entered doesn\'t match with the first password} other {Invalid input. }}'**
  String confirmPasswordError(String error);

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Search by country name'**
  String get searchByCountryName;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a verification code?'**
  String get resendVerificationMessage;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get verifyPhoneNumber;

  /// Shown on the OTP verification screen indicating OTP expiry time
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? we can resend it in {duration}'**
  String timeoutCountDownMessage(String duration);

  /// Shown on the OTP verification screen while verifying phone number during sign up
  ///
  /// In en, this message translates to:
  /// **'Enter the six digit code sent to {phoneNumber}'**
  String enterVerificationCode(String phoneNumber);

  /// Shown on error snack bar when server error occurs.
  ///
  /// In en, this message translates to:
  /// **'Server Error. Please try again later.'**
  String get serverErrorTryAgainLater;

  /// Text shown on different screens for network error.
  ///
  /// In en, this message translates to:
  /// **'{ error, select, cancelled {Request cancelled.} connection {Please check your internet connection and try again.} custom {Something went wrong. Try again.} format {Something went wrong. Try again.} server {Server error. Try again later.} timeout {Connection timeout. Please check your internet connection.} unhandled {Something went wrong.} other {Something went wrong. Try again.}}'**
  String networkErrorMessage(String error);

  /// Show on signup page
  ///
  /// In en, this message translates to:
  /// **'Successfully verified phone number'**
  String get otpVerificationSuccessful;

  /// Shown on the OTP verification screen
  ///
  /// In en, this message translates to:
  /// **'{error, select, invalidOtp{Please enter a valid OTP code.} otpExpired{OTP code expired. Try again.} invalidPhoneNumber{Please enter a valid phone number.} tooManyRequests{Too many requests. Try again later.} timedOut{OTP verification Timed out. Please try again} unknown {Something went wrong. Please try again} other {Invalid input.}}'**
  String otpVerificationErrorMessage(String error);

  /// Shown on signup screen
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberValidationError;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Phone number verification failed'**
  String get phoneNumberVerificationFailed;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Phone number verification timed out'**
  String get phoneNumberVerificationTimedOut;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Successfully created an account'**
  String get signUpSuccessful;

  /// Shown on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6 digit code'**
  String get otpErrorText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
