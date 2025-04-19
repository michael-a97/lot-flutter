import 'package:dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';

import '../../../../l10n/l10n.dart';
import '../../../phone_number_verification/phone_number_verification.dart';
import '../../../shared/shared.dart';
import '../../../shared/widgets/phone_number_input_field.dart';
import '../../sign_up.dart';
import 'otp_verification_dialog/otp_verification_dialog.dart';

part 'confirm_password_input_field.dart';

part 'first_name_input_field.dart';

part 'last_name_input_field.dart';

part 'password_input_field.dart';

part 'signup_phone_number_input_field.dart';

part 'verify_button.dart';

part 'signup_button.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<
          PhoneNumberVerificationCubit,
          PhoneNumberVerificationState
        >(
          listenWhen:
              (prev, current) =>
                  !(prev.status is StatusOtpCodeSent &&
                      current.status is StatusOtpCodeSent &&
                      (prev.isLoading != current.isLoading)),
          listener: _phoneNumberVerificationListener,
        ),
        BlocListener<SignUpCubit, SignUpState>(listener: _signUpListener),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.signUp)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Spacing.lg),
                  children: [
                    const FirstNameInputField(),
                    const Gap(Spacing.lg),
                    const LastNameInputField(),
                    const Gap(Spacing.lg),
                    Row(
                      children: [
                        const Expanded(child: SignUpPhoneNumberInputField()),
                        BlocBuilder<SignUpCubit, SignUpState>(
                          builder: (context, state) {
                            return AnimatedCrossFade(
                              crossFadeState:
                                  state.isPhoneNumberValid
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                              firstCurve: Curves.elasticIn,
                              duration: const Duration(milliseconds: 175),
                              firstChild: const Center(child: SizedBox()),
                              secondChild: const Row(
                                children: [Gap(Spacing.lg), VerifyButton()],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Gap(Spacing.lg),
                    const PasswordInputField(),
                    const Gap(Spacing.lg),
                    const ConfirmPasswordInputField(),
                  ],
                ),
              ),
              const SignUpButton(),
            ],
          ),
        ),
      ),
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

  void _signUpListener(BuildContext context, SignUpState state) {
    if (state.status.isSuccess) {
      showSuccessSnackBar(context, message: context.l10n.signUpSuccessful);
    } else if (state.status.isFailure && state.error != null) {
      showApiOrNetworkErrorSnackBar(context, state.error!);
    } else if (state.status.isInProgress) {
      ProgressIndicatorDialog<SignUpCubit, SignUpState>(
        popWhen: (state) => !state.status.isInProgress,
      ).show(context);
    }
  }
}
