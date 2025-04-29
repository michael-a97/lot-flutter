import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({super.key, this.size = 128, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.svgs.lotLogo,
      height: size,
      width: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcATop) : null,
    );
  }
}
