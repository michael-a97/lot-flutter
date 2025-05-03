import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/sign_in/application/sign_in_cubit.dart';
import 'package:lot/features/sign_in/presentation/widgets/sign_in_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SignInPasswordInputField', () {
    late SignInCubit signInCubit;

    setUp(() {
      signInCubit = MockSignInCubit();
    });

    Future<void> pumpWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: signInCubit,
          child: const Material(child: SignInPasswordInputField()),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      const signInState = SignInState();
      when(() => signInCubit.state).thenAnswer((_) => signInState);
      whenListen(signInCubit, Stream.value(signInState));

      await pumpWidgetUnderTest(tester);

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should update password when text is entered', (tester) async {
      const password = '1234';
      const signInState = SignInState();
      when(() => signInCubit.state).thenAnswer((_) => signInState);
      whenListen(signInCubit, Stream.value(signInState));
      when(
        () => signInCubit.onPasswordChanged(password),
      ).thenAnswer((_) async {});

      await pumpWidgetUnderTest(tester);

      await tester.enterText(find.byType(TextFormField), password);
      await tester.pumpAndSettle();
      verify(() => signInCubit.onPasswordChanged(password)).called(1);
    });

    testWidgets('should toggle password visibility when icon is tapped', (
      tester,
    ) async {
      const signInState = SignInState();
      when(() => signInCubit.state).thenReturn(signInState);
      whenListen(signInCubit, Stream.value(signInState));

      await pumpWidgetUnderTest(tester);

      final iconButtonFinder = find.byType(IconButton);
      expect(iconButtonFinder, findsOneWidget);

      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}

class MockSignInCubit extends Mock implements SignInCubit {}
