final Map<String, bool Function(String)> emailRules = {
  'Длина почтового адреса может быть не менее 5 и не более 320 символов':
      (value) => value.length >= 5 && value.length <= 320,
  'Почтовый адрес может быть в формате example@example.com': (value) =>
      value.isNotEmpty && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value),
  'Только один символ @ должен содержать пароль': (value) =>
      value.split('@').length - 1 == 1
};
