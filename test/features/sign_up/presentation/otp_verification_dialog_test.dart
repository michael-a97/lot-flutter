import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/phone_number_verification/phone_number_verification.dart';
import 'package:lot/features/sign_up/presentation/widgets/otp_verification_dialog/otp_verification_dialog.dart';
import 'package:lot/features/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$OtpVerificationDialog', () {
    late StackRouter router;
    late PhoneNumberVerificationCubit phoneNumberVerificationCubit;
    late SignUpCubit signUpCubit;

    setUp(() {
      router = _MockStackRouter();
      phoneNumberVerificationCubit = _MockPhoneNumberVerificationCubit();
      signUpCubit = _MockSignUpCubit();
    });

    Future<void> pumpWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpApp(
        Material(
          child: StackRouterScope(
            controller: router,
            stateHash: 0,
            child: RouterScope(
              stateHash: 0,
              controller: router,
              navigatorObservers: [NavigatorObserver()],
              inheritableObserversBuilder: () => [],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: phoneNumberVerificationCubit),
                  BlocProvider.value(value: signUpCubit),
                ],
                child: const Scaffold(body: OtpVerificationDialog()),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      const phoneNumber = '+251923000000';
      const phoneNumberState = PhoneNumberVerificationState(
        phoneNumber: phoneNumber,
      );
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);

      expect(find.byType(Pinput), findsOne);
      expect(
        find.text('Enter the six digit code sent to $phoneNumber'),
        findsOne,
      );
      expect(
        find.text("Didn't receive a code? we can resend it in 01:00"),
        findsOne,
      );
      expect(
        find.ancestor(
          of: find.text('Verify'),
          matching: find.byType(ElevatedButton),
        ),
        findsOne,
      );
    });

    testWidgets('should show resend button when count down timer runs out', (
      tester,
    ) async {
      const phoneNumber = '+251923000000';
      const phoneNumberState = PhoneNumberVerificationState(
        phoneNumber: phoneNumber,
      );
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);
      await tester.pump(const Duration(seconds: 61));
      expect(find.byType(Pinput), findsOne);
      expect(
        find.text('Enter the six digit code sent to $phoneNumber'),
        findsOne,
      );
      expect(
        find.text("Didn't receive a code? we can resend it in 01:00"),
        findsNothing,
      );
      expect(find.byType(OtpResendRequestButton), findsOne);
    });

    testWidgets('should call sign up when otp code is valid', (tester) async {
      const phoneNumber = '+251923000000';
      const otp = '123456';
      const phoneNumberState = PhoneNumberVerificationState(
        phoneNumber: phoneNumber,
      );
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);
      when(
        () => phoneNumberVerificationCubit.verifyOtp(otp),
      ).thenAnswer((_) async => const Right(unit));

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);

      expect(find.byType(OtpInputField), findsOne);
      await tester.enterText(find.byType(OtpInputField), otp);
      await tester.tap(find.byType(VerifyOtpButton));

      verify(() => phoneNumberVerificationCubit.verifyOtp(otp)).called(1);
    });
  });
}

class _MockStackRouter extends Mock implements StackRouter {}

class _MockPhoneNumberVerificationCubit extends Mock
    implements PhoneNumberVerificationCubit {}

class _MockSignUpCubit extends Mock implements SignUpCubit {}
