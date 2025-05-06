//coverage:ignore-file
import 'package:auto_route/auto_route.dart';
import 'package:data/data.dart';
import 'package:injectable/injectable.dart';

import '../config.dart';
import 'router.gr.dart';
export 'router.gr.dart';

@injectable
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  static const _unguardedRouteNames = [
    SplashRoute.name,
    SignInRoute.name,
    SignUpRoute.name,
  ];
  final AuthenticationRepository _authenticationRepository;

  AppRouter(this._authenticationRepository);

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AdaptiveRoute(page: SplashRoute.page, initial: true),
    AdaptiveRoute(page: SignUpRoute.page),
    AdaptiveRoute(page: SignInRoute.page),
    AdaptiveRoute(page: HomeRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple((resolver, router) async {
      if (await _authenticationRepository.isUserAuthenticated() ||
          _unguardedRouteNames.contains(resolver.route.name)) {
        resolver.next();
        return;
      } else {
        await resolver.redirectUntil(const SignInRoute());
        return;
      }
    }),
  ];
}
