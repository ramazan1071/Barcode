import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double width;
  final Function(int) onChanged; // Eklenen yeni özellik: onChanged callback

  const CustomNumberInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.width ,
    required this.onChanged, // Eklenen yeni özellik: onChanged callback
  }) : super(key: key);

  @override
  _CustomNumberInputState createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends State<CustomNumberInput> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.controller.text.isNotEmpty
        ? int.parse(widget.controller.text.replaceAll(RegExp(r'[^0-9]'), ''))
        : 0; // Başlangıç değeri atanması
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Sadece sayısal değerler
            LengthLimitingTextInputFormatter(10)
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              int newValue = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));
              setState(() {
                currentValue = newValue;
              });
              // onChanged callback'i ile değeri dışarıya gönder
              widget.onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
