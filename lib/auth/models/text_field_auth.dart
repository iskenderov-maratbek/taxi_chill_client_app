import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class TextFieldAuth extends StatefulWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  final String? prefixText;
  final IconData? prefixIcon;
  final String? prefixImg;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;

  const TextFieldAuth({
    super.key,
    required this.validator,
    required this.controller,
    this.prefixText,
    this.prefixIcon,
    this.prefixImg,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
    this.maxLength,
  });

  @override
  State<TextFieldAuth> createState() => _TextFieldAuthState();
}

class _TextFieldAuthState extends State<TextFieldAuth> {
  late final Widget? _prefix;

  @override
  void initState() {
    if (widget.prefixIcon != null) {
      _prefix = Icon(
        widget.prefixIcon,
        color: Colors.yellow[700],
        size: 25,
      );
    } else if (widget.prefixImg != null) {
      _prefix = Image.asset(
        widget.prefixImg!,
        width: 20,
        fit: BoxFit.contain,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logInfo(runtimeType);
    return TextFormField(
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      maxLength: widget.maxLength,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        fontSize: 18,
      ),
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 5),
              child: _prefix,
            ),
            Text(
              widget.prefixText != null ? '${widget.prefixText} ' : '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            )
          ],
        ),
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 2,
        isDense: true,
        counterText: '',
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
      ),
    );
  }
}
