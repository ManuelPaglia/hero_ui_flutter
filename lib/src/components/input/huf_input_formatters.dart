import 'package:flutter/services.dart';

/// Consente solo caratteri ammessi in un indirizzo email.
class HUFEmailInputFormatter extends TextInputFormatter {
  static final _pattern = RegExp(r'^[a-zA-Z0-9@._%+\-]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_pattern.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

/// Consente solo cifre (per [HUFInputType.tel]).
class HUFDigitsOnlyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits == newValue.text) {
      return newValue;
    }
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
