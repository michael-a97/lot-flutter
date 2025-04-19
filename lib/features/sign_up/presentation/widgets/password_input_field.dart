part of 'sign_up_view.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({super.key});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
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
            context.read<SignUpCubit>().onPasswordChanged(value);
          },
          decoration: InputDecoration(
            labelText: l10n.password,
            errorText: state.form.passwordInput.readError(l10n.passwordError),
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
