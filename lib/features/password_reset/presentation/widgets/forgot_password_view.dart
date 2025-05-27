import 'package:auto_route/auto_route.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';

import '../../../../l10n/l10n.dart';
import '../../../phone_number_verification/phone_number_verification.dart';
import '../../../shared/shared.dart';
import '../../../shared/widgets/phone_number_input_field.dart';
import '../../../sign_up/presentation/widgets/sign_up_view.dart'
    hide VerifyButton;
import '../../application/application.dart';

part 'phone_number_input_field.dart';

part 'password_input_field.dart';

part 'verify_button.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: _listener,
      child: PhoneNumberVerificationListener(
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Spacing.lg),
                  children: [
                    Text(
                      l10n.forgotPasswordTitle,
                      style: context.theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(Spacing.sm),
                    Text(
                      l10n.forgotPasswordSubheading,
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(Spacing.xxxl),
                    Row(
                      children: [
                        const Expanded(
                          child: ForgotPasswordPhoneNumberInputField(),
                        ),
                        BlocBuilder<PasswordResetCubit, PasswordResetState>(
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
                  return Padding(
                    padding: const EdgeInsets.all(Spacing.lg),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PasswordResetCubit>().submit();
                        },
                        child: Text(l10n.resetPassword),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, PasswordResetState state) {
    if (state.status.isSuccess) {
      context.router.pop();
      showSuccessSnackBar(
        context,
        message: context.l10n.successfullyResetPassword,
      );
    } else if (state.status.isFailure && state.error != null) {
      showApiOrNetworkErrorSnackBar(context, state.error!);
    } else if (state.status.isInProgress) {
      ProgressIndicatorDialog<PasswordResetCubit, PasswordResetState>(
        popWhen: (state) => !state.status.isInProgress,
      ).show(context);
    }
  }
}
