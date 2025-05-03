import 'package:auto_route/auto_route.dart';
import 'package:config/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/config/config.dart';
import 'package:lot/features/shared/shared.dart';
import 'package:lot/features/splash/presentation/widgets/splash_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SplashView', () {
    late StackRouter router;

    setUp(() {
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
              child: const SplashView(),
            ),
          ),
        ),
      );
    }

    testWidgets('should render correctly', (tester) async {
      when(() => router.replace(const HomeRoute())).thenAnswer((_) {
        return Future.value();
      });
      AppConfig(version: '123', baseHttpUrl: 'http://localhost:8000');

      await pumpWidgetUnderTest(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(AnimatedAppLogo), findsOne);
      expect(find.text(AppConfig.instance.version), findsOne);
    });
  });
}

class _MockStackRouter extends Mock implements StackRouter {}
