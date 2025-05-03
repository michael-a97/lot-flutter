import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/sign_in/application/application.dart';
import 'package:lot/features/sign_in/presentation/widgets/sign_in_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SignInButton', () {
    late SignInCubit signInCubit;
    setUp(() {
      signInCubit = MockSignInCubit();
    });

    Future<void> pumpWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: signInCubit, child: const SignInButton()),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await pumpWidgetUnderTest(tester);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('should call submit when tapped', (tester) async {
      when(() => signInCubit.submit()).thenAnswer((_) async {});
      const signInState = SignInState();
      whenListen(signInCubit, Stream.value(signInState));
      when(() => signInCubit.state).thenAnswer((_) => signInState);

      await pumpWidgetUnderTest(tester);
      await tester.tap(find.byType(ElevatedButton));

      verify(() => signInCubit.submit()).called(1);
    });
  });
}

class MockSignInCubit extends Mock implements SignInCubit {}
