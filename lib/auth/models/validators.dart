import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/auth/models/rules.dart';

class Validators {
  static String? phoneNumber(String? value) {
    logInfo('Вызов валидатора phoneNumber: $value');
    return null;
  }

  static String? email(String? value) {
    logInfo('Вызов валидатора email: $value');
    return null;
  }

  static String? password(String? value) {
    logInfo('Вызов валидатора password: $value');
    if (value != null && value.isNotEmpty) {
      for (var check in passwordRules.values) {
        if (!check(value)) {
          logError('Неправильный номер или пароль');
          return '';
        }
      }
      logInfo('Пароль правильный');
      return null;
    } else {
      logError('Неправильный номер или пароль ');
      return '';
    }
  }

  static String? username(String? value) {
    logInfo('Вызов валидатора phoneNumber: $value');
    return null;
  }
}
