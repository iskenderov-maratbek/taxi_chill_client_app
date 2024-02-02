import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class AuthService extends ChangeNotifier {
  late final FirebaseAuth _auth;

  AuthService() {
    _auth = FirebaseAuth.instance;
    _auth.setLanguageCode('ru');
    logInfo('Сервис авторизации запущен');
  }

  checkAuth() {
    logInfo('Проверяем авторизацию checkAuth()');
    return _auth.currentUser != null;
  }

  @override
  void dispose() {
    logInfo(' Сервис авторизации dispose');
    super.dispose();
  }

  Future<bool> login({required String email, required String password}) async {
    logInfo('Авторизация пользователя $email');
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      String? token = await credential.user?.getIdToken();
      if (token != null) {
        notifyListeners();
        return true;
      } else {
        logInfo('Ошибка авторизации пользователя $email');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          logError('Ошибка авторизации пользователя ${e.code}');
          break;
        case 'wrong-password':
          logError('Ошибка авторизации пользователя ${e.code}');
          break;
        case 'user-not-found':
          logError('Ошибка авторизации пользователя ${e.code}');
          break;
        case 'user-disabled':
          logError('Ошибка авторизации пользователя ${e.code}');
          break;
        default:
          logError('Ошибка авторизации пользователя ${e.code}');
          break;
      }
    }
    return false;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    logInfo('Регистрация нового пользователя $email');
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? token = await credential.user?.getIdToken();
      if (token != null) {
        return true;
      } else {
        logInfo('Ошибка регистрации пользователя $email');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          logError('Ошибка авторизации: ${e.code}');
          break;
        case 'email-already-in-use':
          logError('Ошибка авторизации: ${e.code}');
          break;
        case 'invalid-email':
          logError('Ошибка авторизации: ${e.code}');
          break;
        case 'operation-not-allowed':
          logError('Ошибка авторизации: ${e.code}');
          break;
        default:
          logError('Ошибка авторизации: ${e.code}');
          break;
      }
      notifyListeners();
    }
    return false;
  }

  Future<bool> restore(email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
            url: 'https://taxi-chill.herokuapp.com/',
            handleCodeInApp: true,
            androidPackageName: 'com.example.taxi_chill',
            androidInstallApp: true,
            iOSBundleId: 'com.example.taxi_chill'),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          logError('Ошибка авторизации: ${e.code}');
          break;
        case 'user-not-found':
          logError('Ошибка авторизации: ${e.code}');
          break;
        default:
          logError('Ошибка авторизации: ${e.code}');
          break;
      }
    }
    return false;
  }

  Future<bool> logout() async {
    logInfo(runtimeType);
    await _auth.signOut();
    notifyListeners();
    return true;
  }
}
