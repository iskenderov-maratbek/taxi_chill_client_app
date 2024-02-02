final Map<String, bool Function(String)> passwordRules = {
  'Пароль может содержать не менее 8 и не более 20 символов': (value) =>
      value.length >= 8 && value.length <= 20,
  'Пароль может содержать только латицинские буквы, цифры и точку': (value) =>
      value.isNotEmpty && value.replaceAll(RegExp('[a-zA-Z0-9.]'), '') == '',
  'Пароль должен содержать хотя бы одну большую букву и цифру': (value) =>
      value.contains(RegExp('[a-z]')) && value.contains(RegExp('[0-9]')),
};

final Map<String, bool Function(String)> emailRules = {
  'Длина почтового адреса может быть не менее 5 и не более 320 символов':
      (value) => value.length >= 5 && value.length <= 320,
  'Почтовый адрес может быть в формате example@example.com': (value) =>
      value.isNotEmpty && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value),
};
