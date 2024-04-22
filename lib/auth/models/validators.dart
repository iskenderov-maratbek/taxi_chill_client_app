import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/auth/models/rules.dart';

class Validators {
  static String? phoneNumber(String? value) {
    logInfo('Вызов валидатора phoneNumber: $value');
    return null;
  }

  static String? email(String? value) {
    logInfo('Вызов валидатора email: $value');
    if (value != null) {
      var i = 0;
      for (var check in emailRules.values) {
        print(i);
        if (!check(value)) {
          logError('Невалидный почтовый адрес');
          return 'Некорректный почтовый адрес';
        }
      }
      logInfo('Валидный почтовый адрес');
      return null;
    } else {
      return 'Укажите электронный адрес';
    }
  }

  static String? username(String? value) {
    logInfo('Вызов валидатора phoneNumber: $value');
    return null;
  }
}
