part of 'sign_in_view.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: l10n.createAccountSignInScreenPrompt,
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: ' ${l10n.signUp} ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    context.router.push(const SignUpRoute());
                  },

            children: [
              TextSpan(text: l10n.now, style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
