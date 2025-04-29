part of 'sign_in_view.dart';

class SignInPhoneNumberInputField extends StatelessWidget {
  const SignInPhoneNumberInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return PhoneNumberInputField(
          onChanged:
              (value) =>
                  context.read<SignInCubit>().onPhoneNumberChanged(value),
          onValidated:
              (value) => context.read<SignInCubit>().onPhoneNumberValidated(
                isValid: value,
              ),
          onSubmitted:
              (value) =>
                  context.read<SignInCubit>().onPhoneNumberChanged(value),
          validationError:
              state.phoneNumberValid
                  ? null
                  : context.l10n.enterAValidPhoneNumber,
        );
      },
    );
  }
}
