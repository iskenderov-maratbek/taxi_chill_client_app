import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:taxi_chill/auth/models/pin_code_form.dart';

Future<bool> showPinCodeDialog(context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const PinCodeDialog();
    },
  );
}

class PinCodeDialog extends StatefulWidget {
  const PinCodeDialog({super.key});

  @override
  State<PinCodeDialog> createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinCodeCoontroller = TextEditingController();

  @override
  void dispose() {
    pinCodeCoontroller.dispose();
    super.dispose();
  }

  String? validator(String? value) {
    if (value != null && value.isNotEmpty && value.length == 4) {
      if (value == '0012') {
        return null;
      } else {
        return 'Неверный код!';
      }
    }
    return 'Неверный код!';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color(0xFFFBC02D)), // Установите цвет границы здесь
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Введите код из SMS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            titlePadding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 15),
                    PinCodeForm(
                      validator: validator,
                      controller: pinCodeCoontroller,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                          20,
                        ),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        'Подтвердить код',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.all(
                            10,
                          ),
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          'Отмена',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
