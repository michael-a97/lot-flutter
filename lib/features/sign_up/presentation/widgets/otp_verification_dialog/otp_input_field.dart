part of 'otp_verification_dialog.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueSetter<String> onCompleted;

  @visibleForTesting
  const OtpInputField({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      listener: _listener,
      child: Pinput(
        length: 6,
        controller: controller,
        defaultPinTheme: PinTheme(
          width: 48,
          height: 48,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
        ),
        // onCompleted: onCompleted,
        animationDuration: const Duration(milliseconds: 100),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  void _listener(BuildContext context, PhoneNumberVerificationState state) {
    final status = state.status;
    if (!state.isLoading && status is StatusOtpVerificationFailed) {
      if (status.error == OtpVerificationError.invalidOtp) {
        controller.clear();
      }
    }
  }
}
