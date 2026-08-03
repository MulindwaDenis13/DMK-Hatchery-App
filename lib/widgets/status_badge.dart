import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final IconData icon;

  const StatusBadge({
    super.key,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
      case 'incubating':
      case 'in_progress':
        color = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'completed':
        color = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        color = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'cancelled':
        color = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        color = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
