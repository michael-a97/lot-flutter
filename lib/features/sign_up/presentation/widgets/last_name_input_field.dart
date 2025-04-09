part of 'sign_up_view.dart';

class LastNameInputField extends StatelessWidget {
  const LastNameInputField({super.key});

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
            context.read<SignUpCubit>().onLastNameChanged(value);
          },
          decoration: InputDecoration(
            labelText: l10n.lastName,
            errorText: state.form.lastName.readError(l10n.nameError),
          ),
        );
      },
    );
  }
}
