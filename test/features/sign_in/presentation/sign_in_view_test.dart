import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:lot/config/router/router.gr.dart';
import 'package:lot/features/shared/shared.dart';
import 'package:lot/features/sign_in/application/sign_in_cubit.dart';
import 'package:lot/features/sign_in/presentation/widgets/sign_in_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/fire_on_tap_gesture_recognizer.dart';
import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SignInView', () {
    late SignInCubit signInCubit;
    late StackRouter router;

    setUp(() {
      signInCubit = MockSignInCubit();
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
                providers: [BlocProvider.value(value: signInCubit)],
                child: const SignInView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      const signInState = SignInState();
      when(() => signInCubit.state).thenReturn(signInState);
      whenListen(signInCubit, Stream.value(signInState));

      await pumpWidgetUnderTest(tester);

      expect(find.text('Sign in'), findsNWidgets(2));
      expect(find.text('Enter your phone number and password'), findsOne);
      expect(find.byType(SignInPhoneNumberInputField), findsOne);
      expect(find.byType(SignInPasswordInputField), findsOne);
      expect(find.byType(SignInButton), findsOne);
    });

    testWidgets('navigates to SignUpRoute on SignUpText tap', (tester) async {
      const signInState = SignInState();
      when(() => signInCubit.state).thenReturn(signInState);
      whenListen(signInCubit, Stream.value(signInState));
      when(() => router.push(const SignUpRoute())).thenAnswer((_) async {
        return null;
      });

      await pumpWidgetUnderTest(tester);

      fireOnTapGestureRecognizer(find.byType(RichText).last, ' Sign Up ');
      await tester.pumpAndSettle();

      verify(() => router.push(const SignUpRoute())).called(1);
    });

    testWidgets('should show progress indicator dialog when loading', (
      tester,
    ) async {
      const signInState = SignInState(status: FormzSubmissionStatus.inProgress);
      when(() => signInCubit.state).thenReturn(signInState);
      when(() => signInCubit.submit()).thenAnswer((_) async {});
      whenListen(
        signInCubit,
        Stream.fromIterable(const [
          SignInState(),
          SignInState(status: FormzSubmissionStatus.inProgress),
        ]),
      );

      await pumpWidgetUnderTest(tester);
      await tester.pump();

      expect(
        find.byType(ProgressIndicatorDialog<SignInCubit, SignInState>),
        findsOne,
      );
    });

    testWidgets('should error snackbar when sign in is unsuccessful', (
      tester,
    ) async {
      const signInState = SignInState(
        status: FormzSubmissionStatus.failure,
        error: ApiNetworkError.timeout(),
      );
      when(() => signInCubit.state).thenReturn(signInState);
      when(() => signInCubit.submit()).thenAnswer((_) async {});
      whenListen(signInCubit, Stream.value(signInState));

      await pumpWidgetUnderTest(tester);

      await tester.tap(find.byType(SignInButton));
    });
  });
}

class MockSignInCubit extends Mock implements SignInCubit {}

class _MockStackRouter extends Mock implements StackRouter {}
