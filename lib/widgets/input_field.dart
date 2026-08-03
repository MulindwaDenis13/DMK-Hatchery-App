import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final VoidCallback? onToggleVisibility;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.green.shade600,
              size: 22,
            ),
            suffixIcon: suffixIcon,
            hintText: hint,
            errorText: errorText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.green.shade600,
                width: 2.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}