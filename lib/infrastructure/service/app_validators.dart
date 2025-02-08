import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  static bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      ).hasMatch(email);

  static bool checkEmail(String email) =>
      RegExp(r"^[0-9 ()+-]+$").hasMatch(email);

  static String? checkUsername(String username) {
    if (username.length < 3) {
      return 'usernameLengthError'.tr();
    }
    var letters = RegExp(r"^[A-Za-z]+$");
    if (!letters.hasMatch(username)) {
      return 'usernameAlphabeticError'.tr();
    }
    return null;
  }

  static bool isValidUsername(String username) {
    return username.length >= 3 && RegExp(r"^[A-Za-z]+$").hasMatch(username);
  }

  static bool isValidPassword(String password) => password.length > 5;

  static String? isNotEmptyValidator(String? title) {
    if (title?.isEmpty ?? true) {
      return 'fieldRequiredError'.tr();
    }
    return null;
  }

  static String? checkName(String name) {
    if (name.length < 2) {
      return 'nameLengthError'.tr();
    }
    var letters = RegExp(r"^[A-Za-z\s]+$");
    if (!letters.hasMatch(name)) {
      return 'nameAlphabeticError'.tr();
    }
    return null;
  }

  static bool validatePrice(String price) {
    const minPrice = 1;
    final priceRegex = RegExp(r'^₺(\d+)(\.\d{1,2})?$');
    if (!priceRegex.hasMatch(price)) {
      return false;
    }
    final priceString = price.replaceFirst('₺', '');
    final priceValue = int.tryParse(priceString.split('.').first) ?? 0;

    return priceValue >= minPrice;
  }
}
