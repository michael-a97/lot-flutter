part of 'sign_up_view.dart';

class SignUpPhoneNumberInputField extends StatelessWidget {
  const SignUpPhoneNumberInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState,
      bool
    >(
      selector: (state) => state.status is! StatusOtpVerificationComplete,
      builder: (context, isEnabled) {
        return BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return PhoneNumberInputField(
              isEnabled: isEnabled,
              initialCountryCode: state.phoneNumber,
              onValidated: (isValid) {
                context.read<SignUpCubit>().onPhoneNumberValidated(
                  isValid: isValid,
                );
              },
              onChanged:
                  (it) => context.read<SignUpCubit>().onPhoneNumberChanged(it),
              borderRadius: 4,
              validationError:
                  state.isPhoneNumberValid != null && !state.isPhoneNumberValid!
                      ? context.l10n.phoneNumberValidationError
                      : null,
            );
          },
        );
      },
    );
  }
}
