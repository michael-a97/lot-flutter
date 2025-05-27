part of 'sign_in_view.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.router.push(const ForgotPasswordRoute()),
      child: Text(context.l10n.forgotPasswordPrompt),
    );
  }
}
