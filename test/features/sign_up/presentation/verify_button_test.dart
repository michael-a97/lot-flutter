import 'package:bloc_test/bloc_test.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/phone_number_verification/phone_number_verification.dart';
import 'package:lot/features/sign_up/application/sign_up_cubit.dart';
import 'package:lot/features/sign_up/presentation/sign_up_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$VerifyButton', () {
    late PhoneNumberVerificationCubit phoneNumberVerificationCubit;
    late SignUpCubit signUpCubit;
    setUp(() {
      phoneNumberVerificationCubit = _MockPhoneNumberVerificationCubit();
      signUpCubit = _MockSignUpCubit();
    });

    Future<void> pumpWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: phoneNumberVerificationCubit,
          child: Material(
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: phoneNumberVerificationCubit),
                BlocProvider.value(value: signUpCubit),
              ],
              child: const VerifyButton(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      const state = PhoneNumberVerificationState();
      whenListen(phoneNumberVerificationCubit, Stream.value(state));
      when(() => phoneNumberVerificationCubit.state).thenReturn(state);

      await pumpWidgetUnderTest(tester);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Verify'), findsOneWidget);
    });

    testWidgets('should display checkmark if verification is complete', (
      tester,
    ) async {
      const state = PhoneNumberVerificationState(
        status: StatusOtpVerificationComplete(),
      );
      whenListen(phoneNumberVerificationCubit, Stream.value(state));
      when(() => phoneNumberVerificationCubit.state).thenReturn(state);

      await pumpWidgetUnderTest(tester);

      expect(find.byIcon(Icons.check_circle), findsOne);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Verify'), findsNothing);
    });

    testWidgets('should requestOtpVerification when tapped', (tester) async {
      const state = PhoneNumberVerificationState();
      whenListen(phoneNumberVerificationCubit, Stream.value(state));
      when(() => phoneNumberVerificationCubit.state).thenReturn(state);
      const phoneNumber = '+251923000000';
      const signUpState = SignUpState(phoneNumber: phoneNumber);
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);
      when(
        () => phoneNumberVerificationCubit.requestOtpVerification(phoneNumber),
      ).thenAnswer((_) async {});

      await pumpWidgetUnderTest(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => phoneNumberVerificationCubit.requestOtpVerification(any()),
      ).called(1);
    });
  });
}

class _MockPhoneNumberVerificationCubit extends Mock
    implements PhoneNumberVerificationCubit {}

class _MockSignUpCubit extends Mock implements SignUpCubit {}
