import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../phone_number_verification/application/phone_number_verification_cubit.dart';
import '../application/application.dart';
import 'widgets/forgot_password_view.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneNumberVerificationCubit>(
          create: (context) => getIt<PhoneNumberVerificationCubit>(),
        ),
        BlocProvider<PasswordResetCubit>(
          create: (context) => getIt<PasswordResetCubit>(),
        ),
      ],
      child: const ForgotPasswordView(),
    );
  }
}
