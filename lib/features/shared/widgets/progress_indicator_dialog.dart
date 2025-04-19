import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'progress_indicator_widget.dart';

class ProgressIndicatorDialog<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final bool dismissible;
  final Function(S state)? popWhen;
  final Function(BuildContext context, S state)? listener;

  const ProgressIndicatorDialog({
    super.key,
    this.listener,
    this.popWhen,
    this.dismissible = true,
  }) : assert(
         listener != null || popWhen != null,
         'either `listener` or `popWhen` must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener:
          listener ??
          (context, state) {
            if (popWhen!(state)) Navigator.of(context).pop();
          },
      child: PopScope(
        canPop: dismissible,
        child: const ProgressIndicatorWidget(),
      ),
    );
  }

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => BlocProvider.value(value: context.read<B>(), child: this),
    );
  }
}
