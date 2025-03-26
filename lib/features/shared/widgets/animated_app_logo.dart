import 'package:flutter/material.dart';

import '../shared.dart';

class AnimatedAppLogo extends StatefulWidget {
  const AnimatedAppLogo({super.key});

  @override
  State<AnimatedAppLogo> createState() => _AnimatedAppLogoState();
}

class _AnimatedAppLogoState extends State<AnimatedAppLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurveTween(curve: Curves.easeOutQuad).animate(_controller),
      child: const AppLogo(),
    );
  }
}
