import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType inputType;
  final bool isPassword;
  const InputField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      keyboardType: inputType,
      obscureText: isPassword,
    );
  }
}
