import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool pressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            pressed ? Colors.blue : Colors.grey.withOpacity(0.5),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            pressed ? Colors.white : Colors.black,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
