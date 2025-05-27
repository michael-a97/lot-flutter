part of 'forgot_password_view.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({super.key});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      builder: (context, state) {
        if (state.status is! StatusOtpVerificationComplete) {
          return const SizedBox();
        }
        return BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
            return TextFormField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onChanged: (value) {
                context.read<PasswordResetCubit>().onPasswordChanged(value);
              },
              decoration: InputDecoration(
                labelText: l10n.newPassword,
                errorText: state.passwordInput.readError(l10n.passwordError),
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
      },
    );
  }
}
