part of 'sign_up_view.dart';

class ConfirmPasswordInputField extends StatefulWidget {
  const ConfirmPasswordInputField({super.key});

  @override
  State<ConfirmPasswordInputField> createState() =>
      _ConfirmPasswordInputFieldState();
}

class _ConfirmPasswordInputFieldState extends State<ConfirmPasswordInputField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return TextFormField(
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            context.read<SignUpCubit>().onConfirmPasswordChanged(value);
          },
          decoration: InputDecoration(
            labelText: l10n.confirmPassword,
            errorText: state.form.confirmPasswordInput.readError(
              l10n.confirmPasswordError,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          obscureText: obscurePassword,
        );
      },
    );
  }
}
