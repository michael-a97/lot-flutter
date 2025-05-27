import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/password_reset/application/application.dart';
import 'package:lot/features/password_reset/presentation/widgets/forgot_password_view.dart';
import 'package:lot/features/phone_number_verification/application/phone_number_verification_cubit.dart';
import 'package:lot/features/shared/widgets/phone_number_input_field.dart';
import 'package:lot/features/sign_up/presentation/widgets/otp_verification_dialog/otp_verification_dialog.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$ForgotPasswordView', () {
    late PasswordResetCubit passwordResetCubit;
    late PhoneNumberVerificationCubit phoneNumberVerificationCubit;
    late StackRouter router;

    setUp(() {
      passwordResetCubit = _MockPasswordResetCubit();
      phoneNumberVerificationCubit = _MockPhoneNumberVerificationCubit();
      router = _MockStackRouter();
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
                  BlocProvider.value(value: passwordResetCubit),
                  BlocProvider.value(value: phoneNumberVerificationCubit),
                ],
                child: const ForgotPasswordView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      const passwordResetState = PasswordResetState();
      when(() => passwordResetCubit.state).thenReturn(passwordResetState);
      whenListen(passwordResetCubit, Stream.value(passwordResetState));

      const phoneNumberVerificationState = PhoneNumberVerificationState();
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberVerificationState);
      whenListen(
        phoneNumberVerificationCubit,
        Stream.value(phoneNumberVerificationState),
      );

      await pumpWidgetUnderTest(tester);

      expect(find.byType(AppBar), findsOne);
      expect(find.text('Forgot Password'), findsOne);
      expect(find.byType(PhoneNumberInputField), findsOne);
    });

    testWidgets(
      'should display phone number verification dialog when OTP is sent',
      (tester) async {
        const passwordResetState = PasswordResetState();
        when(() => passwordResetCubit.state).thenReturn(passwordResetState);
        whenListen(passwordResetCubit, Stream.value(passwordResetState));
        const phoneNumberVerificationState = PhoneNumberVerificationState(
          status: StatusOtpCodeSent(
            phoneNumber: '+251923518843',
            verificationId: '123456',
          ),
        );

        when(
          () => phoneNumberVerificationCubit.state,
        ).thenReturn(phoneNumberVerificationState);
        whenListen(
          phoneNumberVerificationCubit,
          Stream.value(phoneNumberVerificationState),
        );

        await pumpWidgetUnderTest(tester);
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        expect(find.byType(OtpVerificationDialog), findsOne);
      },
    );

    testWidgets(
      'should display new password input field and a password reset button if '
      'PhoneNumberVerificationState is complete',
      (tester) async {
        const passwordResetState = PasswordResetState();
        when(() => passwordResetCubit.state).thenReturn(passwordResetState);
        whenListen(passwordResetCubit, Stream.value(passwordResetState));
        const phoneNumberVerificationState = PhoneNumberVerificationState(
          status: StatusOtpVerificationComplete(),
        );

        when(
          () => phoneNumberVerificationCubit.state,
        ).thenReturn(phoneNumberVerificationState);
        whenListen(
          phoneNumberVerificationCubit,
          Stream.value(phoneNumberVerificationState),
        );

        await pumpWidgetUnderTest(tester);

        expect(find.byType(PasswordInputField), findsOne);
        expect(find.text('Reset password'), findsOne);
      },
    );

    testWidgets('should submit the form when reset password button is tapped', (
      tester,
    ) async {
      const passwordResetState = PasswordResetState();
      when(() => passwordResetCubit.state).thenReturn(passwordResetState);
      whenListen(passwordResetCubit, Stream.value(passwordResetState));
      const phoneNumberVerificationState = PhoneNumberVerificationState(
        status: StatusOtpVerificationComplete(),
      );
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberVerificationState);
      whenListen(
        phoneNumberVerificationCubit,
        Stream.value(phoneNumberVerificationState),
      );
      when(() => passwordResetCubit.submit()).thenAnswer((_) async {});

      await pumpWidgetUnderTest(tester);

      expect(find.byType(PasswordInputField), findsOne);
      expect(find.text('Reset password'), findsOne);
      await tester.tap(find.text('Reset password'));

      verify(() => passwordResetCubit.submit()).called(1);
    });
  });
}

class _MockPasswordResetCubit extends Mock implements PasswordResetCubit {}

class _MockPhoneNumberVerificationCubit extends Mock
    implements PhoneNumberVerificationCubit {}

class _MockStackRouter extends Mock implements StackRouter {}
