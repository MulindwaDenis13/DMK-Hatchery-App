import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage;

  const ProgressBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Incubation Progress',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
