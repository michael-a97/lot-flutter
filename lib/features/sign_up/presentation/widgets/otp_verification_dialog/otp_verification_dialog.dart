import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../phone_number_verification/phone_number_verification.dart';
import '../../../../shared/shared.dart';

part 'otp_input_field.dart';

part 'otp_resend_button.dart';

part 'otp_timeout_counter.dart';

part 'verify_otp_button.dart';

class OtpVerificationDialog extends StatefulWidget {
  const OtpVerificationDialog({super.key});

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      listener: _listener,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<
                  PhoneNumberVerificationCubit,
                  PhoneNumberVerificationState
                >(
                  builder: (context, state) {
                    return BlocBuilder<
                      PhoneNumberVerificationCubit,
                      PhoneNumberVerificationState
                    >(
                      builder: (context, state) {
                        if (state.phoneNumber == null) {
                          return const SizedBox();
                        }
                        return Text(
                          context.l10n.enterVerificationCode(
                            state.phoneNumber!,
                          ),
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    );
                  },
                ),
                const Gap(Spacing.xxl),
                OtpInputField(
                  controller: _controller,
                  onCompleted: (pin) {
                    context.read<PhoneNumberVerificationCubit>().verifyOtp(pin);
                  },
                ),
                const Gap(Spacing.xxxl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
                  child: VerifyOtpButton(controller: _controller),
                ),
                const Gap(Spacing.lg),
                const OtpTimeoutCounter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _listener(BuildContext context, PhoneNumberVerificationState state) {
    final status = state.status;
    if (status is StatusOtpVerificationComplete) {
      showSuccessSnackBar(
        context,
        message: context.l10n.otpVerificationSuccessful,
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          context.router.pop(true);
        }
      });
    } else if (status is StatusOtpVerificationFailed) {
      showErrorSnackBar(
        context,
        message: context.l10n.otpVerificationErrorMessage(status.error.name),
      );
      if (status.error == OtpVerificationError.unknown) {
        context.router.pop(false);
      }
    }
  }
}
