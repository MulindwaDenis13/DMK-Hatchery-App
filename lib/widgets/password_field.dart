import 'package:flutter/material.dart';
import './input_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? errorText;

  const PasswordField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.errorText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return InputField(
      controller: widget.controller,
      label: widget.label,
      icon: Icons.lock_outline,
      hint: widget.hint,
      obscureText: _obscureText,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey.shade500,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
