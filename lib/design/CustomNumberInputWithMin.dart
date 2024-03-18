import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInputWithMin extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double width;
  final int? maxValue; // Yeni parametre: maxValue
  final ValueChanged<String>? onChanged;

  const CustomNumberInputWithMin({
    Key? key,
    required this.controller,
    required this.labelText,
    this.width = 250,
    this.maxValue, // Yeni parametre: maxValue
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomNumberInputWithMinState createState() => _CustomNumberInputWithMinState();
}

class _CustomNumberInputWithMinState extends State<CustomNumberInputWithMin> {
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
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
          ],
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            if (value.isNotEmpty) {
              int enteredValue = int.tryParse(value.replaceAll(RegExp(r'[^0-9-]'), '')) ?? 1;
              if (widget.maxValue != null && enteredValue > widget.maxValue!) {
                setState(() {
                  widget.controller.text = widget.maxValue.toString();
                });
              }
            }
          },
        ),
      ),
    );
  }
}
