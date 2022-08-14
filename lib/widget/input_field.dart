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
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      keyboardType: inputType,
      obscureText: isPassword,
    );
  }
}
