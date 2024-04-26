import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';

class TextFieldForm extends StatelessWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? prefixImg;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;

  const TextFieldForm({
    super.key,
    required this.validator,
    required this.controller,
    this.prefixIcon,
    this.prefixImg,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    logBuild('Модель текстового поля');
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      maxLength: maxLength,
      // textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        fontSize: 18,
        // height: 1,
        // height: 1.5170817,
        // height: 1.50825,
      ),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 5),
              child: Icon(
                prefixIcon,
                color: Colors.yellow[700],
                size: 25,
              ),
            ),
          ],
        ),
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 2,
        counterText: '',
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          // height: 1.6352,
        ),
      ),
    );
  }
}
