part of 'sign_in_view.dart';

class SignInPasswordInputField extends StatefulWidget {
  const SignInPasswordInputField({super.key});

  @override
  State<SignInPasswordInputField> createState() =>
      _SignInPasswordInputFieldState();
}

class _SignInPasswordInputFieldState extends State<SignInPasswordInputField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return TextFormField(
          onChanged:
              (value) => context.read<SignInCubit>().onPasswordChanged(value),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: l10n.password,
            errorText: state.passwordInput.readError(l10n.signInPasswordError),
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
