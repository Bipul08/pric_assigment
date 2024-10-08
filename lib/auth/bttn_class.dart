import 'package:flutter/material.dart';

class ButtonClass extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonClass({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      width: double.infinity, // Full-width button
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        gradient: LinearGradient( // Gradient background for the button
          colors: [Colors.orange.shade600, Colors.orange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade300.withOpacity(0.6),
            blurRadius: 10,
            offset: Offset(0, 5), // Button shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Use transparent color to show the gradient
          shadowColor: Colors.transparent, // Remove default shadow
          padding: EdgeInsets.symmetric(vertical: 18), // Vertical padding inside the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Ensure button shape follows the container's radius
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 18, // Text size
            fontWeight: FontWeight.bold, // Bold text
            letterSpacing: 1.2, // Increase space between letters for a modern look
          ),
        ),
      ),
    );
  }
}
