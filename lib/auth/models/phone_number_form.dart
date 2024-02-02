import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class PhoneNumberForm extends StatelessWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  const PhoneNumberForm(
      {super.key, required this.validator, required this.controller});

  @override
  Widget build(BuildContext context) {
    logBuild(runtimeType);
    return TextFormField(
      validator: validator,
      keyboardType: TextInputType.number,
      controller: controller,
      maxLength: 10,
      style: const TextStyle(
        fontSize: 20,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: const InputDecoration(
        isDense: true,
        counterText: '',
        hintText: '0556777358',
      ),
    );
  }
}
