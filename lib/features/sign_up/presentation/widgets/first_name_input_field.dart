part of 'sign_up_view.dart';

class FirstNameInputField extends StatelessWidget {
  const FirstNameInputField({super.key});

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
            context.read<SignUpCubit>().onFirstNameChanged(value);
          },
          decoration: InputDecoration(
            labelText: l10n.firstName,
            errorText: state.form.firstName.readError(l10n.nameError),
          ),
        );
      },
    );
  }
}
