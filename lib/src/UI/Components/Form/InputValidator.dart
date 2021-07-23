abstract class InputValidator {
  bool isRequired (dynamic value) {
    return value == null || value.isEmpty;
  }
}