import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lot.',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontFamily: 'Boldonse',
      ),
    );
  }
}
