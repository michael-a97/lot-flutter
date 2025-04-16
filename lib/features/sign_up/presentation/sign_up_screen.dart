//coverage:ignore-file
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/config.dart';
import '../../phone_number_verification/phone_number_verification.dart';
import '../application/sign_up_cubit.dart';
import 'widgets/sign_up_view.dart';
export 'widgets/sign_up_view.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(create: (context) => getIt<SignUpCubit>()),
        BlocProvider(
          create: (context) => getIt<PhoneNumberVerificationCubit>(),
        ),
      ],
      child: const SignUpView(),
    );
  }
}
