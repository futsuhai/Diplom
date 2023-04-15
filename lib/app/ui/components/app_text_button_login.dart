import 'package:flutter/material.dart';

class AppTextButtonLogin extends StatelessWidget {
  const AppTextButtonLogin(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor = Colors.black})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          fixedSize: MaterialStateProperty.all<Size>(
              const Size(double.maxFinite, 60))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
