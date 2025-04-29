import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../l10n/l10n.dart';
import '../shared.dart';
import '../theme/theme.dart';

/// Used for phone number input field  a fall back or default value if it is
/// not possible to determine the users country code by other method.
///
/// The default country code is `NG` for Nigeria.
const fallbackCountryCode = 'ET';

class PhoneNumberInputField extends StatefulWidget {
  final bool isEnabled;
  final bool showHintText;
  final double borderRadius;
  final String? initialValue;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final String? initialCountryCode;
  final bool shouldShowErrorMessage;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final ValueChanged<bool>? onValidated;
  final String? Function(String value)? validator;
  final void Function(String phoneNumber)? onChanged;
  final void Function(String phoneNumber)? onSubmitted;
  final void Function(String countryCode)? onCountryCodeChanged;
  final String? validationError;
  final bool keepInitialValueUpdated;
  final List<String> supportedCountries;
  const PhoneNumberInputField({
    super.key,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.controller,
    this.onValidated,
    this.onSubmitted,
    this.initialValue,
    this.contentPadding,
    this.textInputAction,
    this.borderRadius = 8,
    this.isEnabled = true,
    this.initialCountryCode,
    this.showHintText = true,
    this.onCountryCodeChanged,
    this.shouldShowErrorMessage = true,
    this.validationError,
    this.keepInitialValueUpdated = false,
    this.supportedCountries = AppConfig.supportedCountries,
  });

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  late String _countryCode;
  late String _phoneNumber;
  String? _currentErrorMessage;
  late PhoneNumber _initialPhoneNumber;
  late TextEditingController _controller;
  bool _isCurrentPhoneNumberValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InternationalPhoneNumberInput(
            validator: _validate,
            onInputChanged: _onChanged,
            isEnabled: widget.isEnabled,
            focusNode: widget.focusNode,
            onInputValidated: _onValidated,
            textFieldController: _controller,
            initialValue: _initialPhoneNumber,
            keyboardType: TextInputType.number,
            spaceBetweenSelectorAndTextField: 0,
            onFieldSubmitted: widget.onSubmitted,
            keyboardAction: widget.textInputAction,
            countries: widget.supportedCountries,
            selectorTextStyle: context.theme.textTheme.bodyLarge,
            selectorConfig: const SelectorConfig(
              leadingPadding: 12,
              trailingSpace: false,
              setSelectorButtonAsPrefixIcon: true,
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            searchBoxDecoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: context.l10n.searchByCountryName,
              contentPadding: const EdgeInsets.only(
                bottom: 14,
                right: 8,
                left: 8,
              ),
            ),
          ),
        ),
        if ((_currentErrorMessage != null && widget.shouldShowErrorMessage) ||
            widget.validationError != null)
          ValidationErrorText(
            errorMessage: widget.validationError ?? _currentErrorMessage!,
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(PhoneNumberInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keepInitialValueUpdated) {
      if (oldWidget.controller != widget.controller &&
          oldWidget.controller == null &&
          widget.controller != null) {
        _controller.dispose();
        _controller = widget.controller!;
      }

      if (oldWidget.initialValue != widget.initialValue) {
        final oldInitialValue = oldWidget.initialValue;
        final newInitialValue = widget.initialValue ?? '';
        final isUpdate =
            (oldInitialValue == null || oldInitialValue.isEmpty) &&
            newInitialValue.isNotEmpty;
        if (isUpdate) {
          _phoneNumber = newInitialValue;
          _initializeInitialPhoneNumber();
          _initialize(isUpdate: true);
        }
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _countryCode = widget.initialCountryCode ?? fallbackCountryCode;
    _phoneNumber = widget.initialValue ?? '';
    _initializeInitialPhoneNumber();
    _initialize();
  }

  Future<void> _initialize({bool isUpdate = false}) async {
    try {
      final initialPhoneNumber = widget.initialValue?.trim();
      if (initialPhoneNumber != null && initialPhoneNumber.isNotEmpty) {
        await _setCountryCodeFromPhoneNumber(initialPhoneNumber);
      }
      _initializeInitialPhoneNumber();
    } on Exception catch (_) {
      if (isUpdate) _controller.text = _phoneNumber;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _initializeInitialPhoneNumber() {
    _initialPhoneNumber = PhoneNumber(
      phoneNumber: _phoneNumber,
      isoCode: _countryCode,
    );
  }

  void _onChanged(PhoneNumber value) {
    if (value.isoCode != null && value.isoCode != _countryCode) {
      _countryCode = value.isoCode!;
      widget.onCountryCodeChanged?.call(_countryCode);
    }
    if ((value.phoneNumber?.length ?? 0) > _countryCode.length) {
      _phoneNumber = value.phoneNumber!;
    } else {
      _phoneNumber = '';
    }
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    widget.onChanged?.call(_phoneNumber);
  }

  void _onValidated(bool value) {
    widget.onValidated?.call(value);
    _isCurrentPhoneNumberValid = value;
  }

  Future<void> _setCountryCodeFromPhoneNumber(String phoneNumber) async {
    final parsed = await parse(phoneNumber);
    _countryCode = parsed['region_code'];
  }

  String? _validate(String? val) {
    _currentErrorMessage =
        _isCurrentPhoneNumberValid
            ? null
            : widget.validator?.call(_phoneNumber);
    setState(() {});
    return null;
  }
}

class ValidationErrorText extends StatelessWidget {
  final String errorMessage;

  const ValidationErrorText({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        errorMessage,
        style: context.theme.textTheme.bodySmall!.copyWith(
          color: context.theme.colorScheme.error,
        ),
      ),
    );
  }
}
