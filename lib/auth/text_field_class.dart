import 'package:flutter/material.dart';

class TextFieldClass extends StatelessWidget {
  final String hintText;
  final ValueKey<String> key;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const TextFieldClass({
    required this.hintText,
    required this.key,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the text field
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        key: key,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Padding inside the text field
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
          fillColor: Colors.white,
          filled: true, // Fill the background color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade600, width: 1.8),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
