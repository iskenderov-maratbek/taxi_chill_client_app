import 'package:flutter/material.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class EmailForm extends StatelessWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  const EmailForm(
      {super.key, required this.validator, required this.controller});

  @override
  Widget build(BuildContext context) {
    logBuild(runtimeType);
    return TextFormField(
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      maxLength: 320,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: const InputDecoration(
        isDense: true,
        counterText: '',
        hintText: 'example@example.com',
      ),
    );
  }
}
