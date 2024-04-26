import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';

class PinCodeForm extends StatelessWidget {
  PinCodeForm({super.key, required this.validator, required this.controller});

  final String? Function(String?) validator;
  final TextEditingController controller;

  final double borderWidth = 3;

  final defaultPinTheme = PinTheme(
    width: 70,
    height: 80,
    textStyle: const TextStyle(
      fontSize: 30,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      color: Colors.grey,
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  late final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(
      color: const Color(0xFFFBC02D),
      width: borderWidth,
    ),
  );

  late final errorPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(
      color: Colors.red,
      width: borderWidth,
    ),
  );

  late final submittedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(
      color: const Color(0xFFFBC02D),
      width: borderWidth,
    ),
  );

  @override
  Widget build(BuildContext context) {
    logBuild('Форма пин-кода');
    return Pinput(
      validator: validator,
      autofocus: true,
      controller: controller,
      length: 4,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ],
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      pinAnimationType: PinAnimationType.none,
      // separatorBuilder: (c) {
      //   return const SizedBox(width: 10);
      // },
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
      mainAxisAlignment: MainAxisAlignment.center,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorPinTheme: errorPinTheme,
      submittedPinTheme: submittedPinTheme,
      closeKeyboardWhenCompleted: false,
    );
  }
}
