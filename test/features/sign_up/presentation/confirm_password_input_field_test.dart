import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/sign_up/presentation/widgets/sign_up_view.dart';
import 'package:lot/features/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$ConfirmPasswordInputField', () {
    late SignUpCubit signUpCubit;

    setUp(() {
      signUpCubit = _MockSignUpCubit();
    });

    Future<void> pumpWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: signUpCubit,
          child: const Material(child: ConfirmPasswordInputField()),
        ),
      );
    }

    testWidgets('should render correctly', (tester) async {
      const signUpState = SignUpState();
      when(() => signUpCubit.state).thenReturn(signUpState);
      whenListen(signUpCubit, Stream.value(signUpState));

      await pumpWidgetUnderTest(tester);

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should call onConfirmPasswordChanged when text changes', (
      tester,
    ) async {
      const signUpState = SignUpState();
      when(() => signUpCubit.state).thenReturn(signUpState);
      whenListen(signUpCubit, Stream.value(signUpState));

      await pumpWidgetUnderTest(tester);

      await tester.enterText(find.byType(TextFormField), 'new password');
      verify(
        () => signUpCubit.onConfirmPasswordChanged('new password'),
      ).called(1);
    });

    testWidgets('should toggle password visibility when icon is tapped', (
      tester,
    ) async {
      const signUpState = SignUpState();
      when(() => signUpCubit.state).thenReturn(signUpState);
      whenListen(signUpCubit, Stream.value(signUpState));

      await pumpWidgetUnderTest(tester);

      final iconButtonFinder = find.byType(IconButton);
      expect(iconButtonFinder, findsOneWidget);

      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}

class _MockSignUpCubit extends Mock implements SignUpCubit {}
