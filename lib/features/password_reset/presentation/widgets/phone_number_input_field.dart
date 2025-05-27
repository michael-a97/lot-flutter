part of 'forgot_password_view.dart';

class ForgotPasswordPhoneNumberInputField extends StatelessWidget {
  const ForgotPasswordPhoneNumberInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState,
      bool
    >(
      selector: (state) => state.status is! StatusOtpVerificationComplete,
      builder: (context, isEnabled) {
        return BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
            return PhoneNumberInputField(
              isEnabled: isEnabled,
              initialCountryCode: state.phoneNumber,
              onValidated: (isValid) {
                context.read<PasswordResetCubit>().onPhoneNumberValidated(
                  isValid: isValid,
                );
              },
              onChanged:
                  (it) => context
                      .read<PasswordResetCubit>()
                      .onPhoneNumberChanged(it),
              borderRadius: 4,
              validationError:
                  state.phoneNumber != null &&
                          !(state.isPhoneNumberValid ?? false)
                      ? context.l10n.phoneNumberValidationError
                      : null,
            );
          },
        );
      },
    );
  }
}
