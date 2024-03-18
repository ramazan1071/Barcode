
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Değişiklik: Başlık solda hizalanacak
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(width: 8), // Değişiklik: İkon ile başlık arasına boşluk eklendi
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      actions: [
        ElevatedButton( // Değişiklik: TextButton yerine ElevatedButton kullanıldı
          onPressed: onPressed,
          child: Text("Tamam"),
        ),
      ],
    );
  }
}
