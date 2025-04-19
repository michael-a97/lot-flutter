part of 'otp_verification_dialog.dart';

class VerifyOtpButton extends StatelessWidget {
  final TextEditingController controller;

  @visibleForTesting
  const VerifyOtpButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<PhoneNumberVerificationCubit>().verifyOtp(
            controller.text,
          );
        },
        child: Text(context.l10n.verify),
      ),
    );
  }
}
