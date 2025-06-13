
import 'package:ww1_map/utils/tr_entry.dart';

class TextFieldState {
  TextFieldState({
    required this.value,
    this.defaultValue,
    this.error,
    this.validated = false,
  });
  final String value;
  final String? defaultValue;
  final TrEntry? error;
  final bool validated;

  TextFieldState copyWith({
    String? value,
    String? defaultValue,
    TrEntry? error,
    bool? validated,
  }) {
    return TextFieldState(
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
      error: error ?? this.error,
      validated: validated ?? this.validated,
    );
  }
}
