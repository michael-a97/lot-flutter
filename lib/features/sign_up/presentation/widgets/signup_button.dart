part of 'sign_up_view.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.xl),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.read<SignUpCubit>().submit(),
          child: Text(context.l10n.signUp),
        ),
      ),
    );
  }
}
