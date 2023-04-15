import 'package:flutter/material.dart';

class IconsButtonLogin extends StatelessWidget {
  const IconsButtonLogin({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200]),
      child: Image.asset(
        imagePath,
        height: 60,
      ),
    );
  }
}
