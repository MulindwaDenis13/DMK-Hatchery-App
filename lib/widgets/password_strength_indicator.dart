import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordStrengthIndicator({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isMet ? Colors.green.shade600 : Colors.grey.shade400,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? Colors.grey.shade800 : Colors.grey.shade500,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}