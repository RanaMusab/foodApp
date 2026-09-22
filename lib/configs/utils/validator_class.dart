import 'package:food_app/configs/resources/resources.dart';

class FieldValidators {


  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return R.strings.nameIsRequired;
    }
    return null;
  }

  static String? emailValidator(String? email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email?.isEmpty ?? false) {
      return R.strings.pleaseEnterYourEmail;
    } else if (!emailRegex.hasMatch(email ?? '')) {
      return R.strings.pleaseEnterAValidEmailAddress;
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return R.strings.pleaseEnterYourPassword;
    }

    if (password.length < 8) {
      return R.strings.passwordMustBeAtLeast8CharactersLong;
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      return R.strings.passwordMustContainAtLeastOneLowercaseLetter;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      return R.strings.passwordMustContainAtLeastOneUppercaseLetter;
    }

    // Check for at least one digit
    if (!RegExp(r'^(?=.*\d)').hasMatch(password)) {
      return R.strings.passwordMustContainAtLeastOneNumber;
    }

    // Check for at least one special character
    if (!RegExp(r'^(?=.*[@$!%*?&^#_=+(){}[\]:;"<>,./|\\~`])').hasMatch(password)) {
      return R.strings.passwordMustContainAtLeastOneSpecialCharacter;
    }

    return null; // Password is valid
  }

  static String? confirmPasswordValidator(String? confirmPassword,String confirmPass) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return R.strings.pleaseConfirmYourPassword;
    } else if (confirmPassword != confirmPass) {
      return R.strings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? newPasswordValidator(String? newPassword,String oldPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return R.strings.pleaseConfirmYourPassword;
    } else if (newPassword == oldPassword) {
      return R.strings.newPasswordMustBeDifferent;
    } else {
      return passwordValidator(newPassword);
    }
  }

  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return R.strings.thisFieldCannotBeEmpty;
    }
    return null;
  }
}
