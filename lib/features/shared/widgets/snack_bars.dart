import 'package:data/data.dart';
import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

void showApiOrNetworkErrorSnackBar(
  BuildContext context,
  ApiNetworkError error,
) {
  showNetworkErrorSnackBar(message: (it) => it.message, context, error);
}

void showErrorSnackBar(
  BuildContext context, {
  String? title,
  required String message,
  Duration? duration,
  bool clearCurrentSnackBar = false,
  SnackBarAction? action,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (clearCurrentSnackBar) {
    scaffoldMessenger.clearSnackBars();
  }
  scaffoldMessenger.showSnackBar(
    SnackBar(
      elevation: 2,
      behavior: SnackBarBehavior.floating,
      content: _SnackBarMessage(
        title: title,
        message: message,
        icon: const Icon(Icons.error, color: Colors.red),
      ),
      duration: duration ?? const Duration(seconds: 4),
      action: action,
    ),
  );
}

void showNetworkErrorSnackBar<T>(
  BuildContext context,
  NetworkError<T> error, {
  String? Function(T error)? message,
}) {
  final l10n = context.l10n;
  switch (error) {
    case ResponseError(error: final it):
      final errorMessage = message?.call(it);
      if (errorMessage != null) {
        showErrorSnackBar(context, message: errorMessage);
      } else if (it case ApiError() when it.message != null) {
        showErrorSnackBar(context, message: it.message!);
      } else {
        showErrorSnackBar(context, message: l10n.serverErrorTryAgainLater);
      }
    case NetworkError():
      showErrorSnackBar(context, message: l10n.networkErrorMessage(error.name));
  }
}

void showSuccessSnackBar(
  BuildContext context, {
  String? title,
  Duration? duration,
  required String message,
  SnackBarAction? snackBarAction,
  bool clearCurrentSnackBar = false,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (clearCurrentSnackBar) {
    scaffoldMessenger.clearSnackBars();
  }
  scaffoldMessenger.showSnackBar(
    SnackBar(
      elevation: 2,
      action: snackBarAction,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 4),
      content: _SnackBarMessage(
        title: title,
        message: message,
        icon: const Icon(Icons.info, color: Colors.green),
      ),
    ),
  );
}

class _SnackBarMessage extends StatelessWidget {
  final Icon? icon;
  final String? title;
  final String message;

  const _SnackBarMessage({this.icon, this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 32),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (icon != null)
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.all(2),
                    ),
                  ),
                  icon!,
                ],
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  if (title != null) const SizedBox(height: 4),
                  Text(
                    message,
                    style:
                        title == null
                            ? theme.textTheme.titleLarge!.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            )
                            : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
