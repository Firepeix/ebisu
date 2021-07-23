abstract class InputValidator {
  bool isRequired (dynamic value) {
    return value == null || (value is String && value.isEmpty);
  }
}