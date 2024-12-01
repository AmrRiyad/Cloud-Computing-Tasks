abstract class IValidationService {
  String? validateEmail(String? value);

  String? validateNotEmpty(String? value);

  String? validatePassword(String? value);
}

class ValidationService implements IValidationService {
  // Singleton instance
  static final ValidationService _instance = ValidationService._internal();

  // Private constructor
  ValidationService._internal();

  // Factory constructor to return the singleton instance
  factory ValidationService() {
    return _instance;
  }

  // Regular expression pattern for validating email format
  final _emailPattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';

  @override
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'emailRequired';
    } else if (!RegExp(_emailPattern).hasMatch(value)) {
      return 'emailNotValid';
    }
    return null;
  }

  @override
  String? validateNotEmpty(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'validateNotEmpty';
    }
    return null;
  }

  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'passwordRequired';
    } else if (value.length < 8 || value.length > 20) {
      return 'passwordLength';
    }
    return null;
  }
}