import 'package:flutter/material.dart';

class AppTextFieldProfile extends StatelessWidget {
  const AppTextFieldProfile(
      {Key? key,
        required this.controller,
        required this.labelText,
        this.obscureText = false})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: emptyValidator,
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color.fromRGBO(140, 140, 139, 1)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromRGBO(35, 34, 32, 1)),
              borderRadius: BorderRadius.circular(14)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: const Color.fromRGBO(35, 34, 32, 1),
          filled: true
      ),
    );
  }

  String? emptyValidator(String? value) {
    if (value?.isEmpty == true) {
      return "Obligatory field";
    } else {
      return null;
    }
  }
}
