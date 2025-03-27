import 'package:flutter_test/flutter_test.dart';
import 'package:lot/config/app/app_config.dart';
import 'package:lot/features/shared/shared.dart';
import 'package:lot/features/splash/presentation/widgets/splash_view.dart';

import '../../../helpers/presentation/pump_app.dart';

void main() {
  group('$SplashView', () {
    testWidgets('should render correctly', (tester) async {
      AppConfig(version: '123');
      await tester.pumpApp(const SplashView());
      expect(find.byType(AnimatedAppLogo), findsOne);
      expect(find.text(AppConfig.instance.version), findsOne);
    });
  });
}
