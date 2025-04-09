import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double dimension = 100;
    return Center(
      child: Container(
        width: dimension,
        height: dimension,
        padding: const EdgeInsets.all(16),
        child: Center(
          child:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 36,
                  )
                  : SizedBox(
                    height: 72,
                    width: 72,
                    child: CircularProgressIndicator(
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor: context.theme.primaryColor.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
