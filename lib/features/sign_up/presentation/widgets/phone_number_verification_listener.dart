part of 'sign_up_view.dart';

class PhoneNumberVerificationListener extends StatelessWidget {
  final Widget? child;

  const PhoneNumberVerificationListener({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      listenWhen:
          (prev, current) =>
              !(prev.status is StatusOtpCodeSent &&
                  current.status is StatusOtpCodeSent &&
                  (prev.isLoading != current.isLoading)),
      listener: _phoneNumberVerificationListener,
      child: child,
    );
  }

  void _phoneNumberVerificationListener(
    BuildContext context,
    PhoneNumberVerificationState state,
  ) {
    if (state.status is StatusOtpCodeSent && !state.isLoading) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (context.mounted) {
          await showModalBottomSheet(
            context: context,
            builder: (_) {
              return BlocProvider<PhoneNumberVerificationCubit>.value(
                value: context.read<PhoneNumberVerificationCubit>(),
                child: const OtpVerificationDialog(),
              );
            },
          );
          if (context.mounted) {
            final state = context.read<PhoneNumberVerificationCubit>().state;
            if (state.status is! StatusOtpVerificationComplete) {
              await context
                  .read<PhoneNumberVerificationCubit>()
                  .resetForResend();
            }
          }
        }
      });
    } else if (state.isLoading) {
      ProgressIndicatorDialog<
        PhoneNumberVerificationCubit,
        PhoneNumberVerificationState
      >(popWhen: (state) => !state.isLoading).show(context);
    } else if (state.status is StatusOtpVerificationFailed) {
      showErrorSnackBar(
        context,
        message: context.l10n.phoneNumberVerificationFailed,
      );
    } else if (state.status is StatusOtpRequestTimedOut) {
      showErrorSnackBar(
        context,
        message: context.l10n.phoneNumberVerificationTimedOut,
      );
    }
  }
}
