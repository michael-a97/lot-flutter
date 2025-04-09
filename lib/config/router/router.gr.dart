// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:lot/features/sign_up/presentation/sign_up_screen.dart' as _i1;
import 'package:lot/features/splash/presentation/splash_screen.dart' as _i2;

/// generated route for
/// [_i1.SignUpScreen]
class SignUpRoute extends _i3.PageRouteInfo<void> {
  const SignUpRoute({List<_i3.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i2.SplashScreen]
class SplashRoute extends _i3.PageRouteInfo<void> {
  const SplashRoute({List<_i3.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.SplashScreen();
    },
  );
}
