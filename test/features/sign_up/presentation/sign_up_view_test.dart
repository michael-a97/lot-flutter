import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:lot/features/phone_number_verification/phone_number_verification.dart';
import 'package:lot/features/shared/shared.dart';
import 'package:lot/features/shared/widgets/phone_number_input_field.dart';
import 'package:lot/features/sign_up/application/sign_up_cubit.dart';
import 'package:lot/features/sign_up/presentation/widgets/sign_up_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SignUpView', () {
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
                child: const SignUpView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should render correctly', (tester) async {
      const phoneNumberState = PhoneNumberVerificationState();
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);

      expect(find.byType(FirstNameInputField), findsOne);
      expect(find.byType(LastNameInputField), findsOne);
      expect(find.byType(PasswordInputField), findsOne);
      expect(find.byType(PhoneNumberInputField), findsOne);
      expect(find.byType(ConfirmPasswordInputField), findsOne);
      expect(
        find.ancestor(of: find.text('Sign Up'), matching: find.byType(AppBar)),
        findsOne,
      );
      expect(find.byType(SignUpButton), findsOne);
      final animatedCrossFade = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(animatedCrossFade.crossFadeState, CrossFadeState.showFirst);
    });

    testWidgets('should show a progress indicator when loading', (
      tester,
    ) async {
      const phoneNumberState = PhoneNumberVerificationState(isLoading: true);
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);

      await tester.pump();
      expect(
        find.byType(
          ProgressIndicatorDialog<
            PhoneNumberVerificationCubit,
            PhoneNumberVerificationState
          >,
        ),
        findsOne,
      );
    });

    testWidgets('should show an error Snackbar when otp verification fails', (
      tester,
    ) async {
      const phoneNumberState = PhoneNumberVerificationState(
        status: StatusOtpVerificationFailed(OtpVerificationError.invalidOtp),
      );
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState();
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);
      await tester.pump();

      expect(
        find.ancestor(
          of: find.text('Phone number verification failed'),
          matching: find.byType(SnackBar),
        ),
        findsOne,
      );
    });

    testWidgets(
      'should show an error Snackbar when otp verification times out',
      (tester) async {
        const phoneNumberState = PhoneNumberVerificationState(
          status: StatusOtpRequestTimedOut('test verification id'),
        );
        whenListen(
          phoneNumberVerificationCubit,
          Stream.value(phoneNumberState),
        );
        when(
          () => phoneNumberVerificationCubit.state,
        ).thenReturn(phoneNumberState);
        const signUpState = SignUpState();
        whenListen(signUpCubit, Stream.value(signUpState));
        when(() => signUpCubit.state).thenReturn(signUpState);

        await pumpWidgetUnderTest(tester);
        await tester.pump();

        expect(
          find.ancestor(
            of: find.text('Phone number verification timed out'),
            matching: find.byType(SnackBar),
          ),
          findsOne,
        );
      },
    );

    testWidgets('should show verify button when phone number is valid', (
      tester,
    ) async {
      const phoneNumberState = PhoneNumberVerificationState();
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);

      const signUpState = SignUpState(isPhoneNumberValid: true);
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);
      await tester.pump();

      final animatedCrossFade = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );

      expect(animatedCrossFade.crossFadeState, CrossFadeState.showSecond);
    });

    testWidgets('should show an success Snackbar when signup is successful', (
      tester,
    ) async {
      const phoneNumberState = PhoneNumberVerificationState();
      whenListen(phoneNumberVerificationCubit, Stream.value(phoneNumberState));
      when(
        () => phoneNumberVerificationCubit.state,
      ).thenReturn(phoneNumberState);
      const signUpState = SignUpState(status: FormzSubmissionStatus.success);
      whenListen(signUpCubit, Stream.value(signUpState));
      when(() => signUpCubit.state).thenReturn(signUpState);

      await pumpWidgetUnderTest(tester);
      await tester.pump();

      expect(
        find.ancestor(
          of: find.text('Successfully created an account'),
          matching: find.byType(SnackBar),
        ),
        findsOne,
      );
    });
  });
}

class _MockStackRouter extends Mock implements StackRouter {}

class _MockPhoneNumberVerificationCubit extends Mock
    implements PhoneNumberVerificationCubit {}

class _MockSignUpCubit extends Mock implements SignUpCubit {}
