part of 'sign_in_view.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.read<SignInCubit>().submit(),
        child: Text(l10n.signIn),
      ),
    );
  }
}
