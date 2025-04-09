part of 'otp_verification_dialog.dart';

class OtpRequestProgressIndicatorDialog extends StatelessWidget {
  const OtpRequestProgressIndicatorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const dimension = 128.0;
    return BlocListener<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      listener: _listener,
      child: Center(
        child: Card(
          color: Colors.grey.shade900.withValues(alpha: .8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: dimension,
            height: dimension,
            padding: const EdgeInsets.all(16),
            child: Center(
              child:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 20,
                      )
                      : const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BlocProvider.value(
            value: context.read<PhoneNumberVerificationCubit>(),
            child: this,
          ),
    );
  }

  void _listener(BuildContext context, PhoneNumberVerificationState state) {
    if (!state.isLoading) context.router.pop();
  }
}
