import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';

import '../../../../config/config.dart';
import '../../../../l10n/l10n.dart';
import '../../../shared/shared.dart';
import '../../../shared/widgets/phone_number_input_field.dart';
import '../../application/application.dart';

part 'phone_number_input_field.dart';

part 'password_input_field.dart';

part 'sign_in_button.dart';

part 'sign_up_text.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: _listener,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    children: [
                      const Gap(Spacing.xxxl),
                      Text(
                        l10n.signIn,
                        style: context.theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Spacing.sm),
                      Text(
                        l10n.signInScreenSubTitle,
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Gap(Spacing.xxxl),
                      const SignInPhoneNumberInputField(),
                      const Gap(Spacing.lg),
                      const SignInPasswordInputField(),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: Spacing.xxl,
                    left: Spacing.lg,
                    right: Spacing.lg,
                  ),
                  child: Column(
                    children: [
                      Gap(Spacing.xxl),
                      SignInButton(),
                      Gap(Spacing.lg),
                      SignUpText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, SignInState state) {
    if (state.status.isInProgress) {
      ProgressIndicatorDialog<SignInCubit, SignInState>(
        popWhen: (state) => !state.status.isInProgress,
      ).show(context);
    } else if (state.status.isFailure) {
      showApiOrNetworkErrorSnackBar(context, state.error!);
    }
  }
}
