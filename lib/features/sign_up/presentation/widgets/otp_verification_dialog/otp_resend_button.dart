part of 'otp_verification_dialog.dart';

class OtpResendRequestButton extends StatefulWidget {
  const OtpResendRequestButton({super.key});

  @override
  State<OtpResendRequestButton> createState() => _OtpResendRequestButtonState();
}

class _OtpResendRequestButtonState extends State<OtpResendRequestButton> {
  final _gestureRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: l10n.resendVerificationMessage,
        style: theme.textTheme.bodyMedium,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.resend,
            recognizer: _gestureRecognizer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColorDark,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _gestureRecognizer.onTap =
        () =>
            context
                .read<PhoneNumberVerificationCubit>()
                .resendOtpVerification();
  }
}
