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

part 'phone_number_verification_listener.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: _listener,
      child: PhoneNumberVerificationListener(
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(Spacing.lg),
                    children: [
                      Text(
                        l10n.signUp,
                        style: context.theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Spacing.sm),
                      Text(
                        l10n.fillFormToCreateAccount,
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Gap(Spacing.xxxl),
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
                                    (state.isPhoneNumberValid ?? false)
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
                BlocBuilder<
                  PhoneNumberVerificationCubit,
                  PhoneNumberVerificationState
                >(
                  builder: (context, state) {
                    if (state.status is! StatusOtpVerificationComplete) {
                      return const SizedBox();
                    }
                    return const SignUpButton();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, SignUpState state) {
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
