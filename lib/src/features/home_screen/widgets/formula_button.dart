import 'package:flutter/material.dart';

class FormulaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FormulaButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
