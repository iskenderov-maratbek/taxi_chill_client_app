import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class AuthService extends ChangeNotifier {
  AuthService() {
    logInfo('Сервис авторизации запущен');
  }

  checkAuth() {
    logInfo('Проверяем авторизацию checkAuth()');
    return false;
  }

  Future<bool> login({required String email}) async {
    logInfo('Авторизация пользователя $email');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.8.100:3000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': 'Hello World',
        }),
      );
      logInfo(response);
      if (response.statusCode == 201) {
        // Если сервер возвращает ответ OK, то парсим JSON.
        print('Data posted successfully');
        return true;
      } else {
        // Если ответ не OK, то выкидываем ошибку.
        throw Exception(response.body);
      }
    } catch (e) {
      logInfo(e.toString());
      return false;
    }
  }

  Future<bool> register(
      {required String email, required String password}) async {
    logInfo('Регистрация нового пользователя $email');
    try {
      logInfo('Ошибка регистрации пользователя $email');
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> restore(email) async {
    try {
      return true;
    } catch (e) {}
    return false;
  }

  Future<bool> logout() async {
    return true;
  }
}
