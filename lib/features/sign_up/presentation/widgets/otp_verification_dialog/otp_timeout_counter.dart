part of 'otp_verification_dialog.dart';

class OtpTimeoutCounter extends StatefulWidget {
  @visibleForTesting
  const OtpTimeoutCounter({super.key});

  @override
  State<OtpTimeoutCounter> createState() => _OtpTimeoutCounterState();
}

class _OtpTimeoutCounterState extends State<OtpTimeoutCounter> {
  Timer? _timer;
  Duration? _timeoutDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<
      PhoneNumberVerificationCubit,
      PhoneNumberVerificationState
    >(
      listener: _listener,
      child:
          (_timer?.isActive ?? false)
              ? Text(
                l10n.timeoutCountDownMessage(
                  l10n.formattedOtpTimeoutDuration(_timeoutDuration!),
                ),
                textAlign: TextAlign.center,
              )
              : const OtpResendRequestButton(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    _timer?.cancel();
    if (mounted) setState(() {});
  }

  void _listener(BuildContext context, PhoneNumberVerificationState state) {
    final status = state.status;
    if (status is StatusOtpCodeSent) {
      _startTimer();
    } else if (status is StatusOtpRequestTimedOut) {
      _cancelTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeoutDuration = resendOtpRequestTimeoutDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), _timerListener);
  }

  void _timerListener(Timer timer) {
    if (_timeoutDuration != null && _timeoutDuration!.inSeconds > 0) {
      _timeoutDuration = _timeoutDuration! - const Duration(seconds: 1);
      if (mounted) setState(() {});
    } else {
      _cancelTimer();
    }
  }
}
