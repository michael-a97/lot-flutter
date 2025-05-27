part of 'forgot_password_view.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      builder: (context, state) {
        return BlocBuilder<
          PhoneNumberVerificationCubit,
          PhoneNumberVerificationState
        >(
          builder: (context, state) {
            if (state.status is StatusOtpVerificationComplete) {
              return Icon(
                Icons.check_circle,
                color: context.theme.primaryColor,
              );
            }
            return ElevatedButton(
              onPressed: () {
                final phoneNumber =
                    context.read<PasswordResetCubit>().state.phoneNumber!;
                context
                    .read<PhoneNumberVerificationCubit>()
                    .requestOtpVerification(phoneNumber);
              },
              child: Text(context.l10n.verify),
            );
          },
        );
      },
    );
  }
}
