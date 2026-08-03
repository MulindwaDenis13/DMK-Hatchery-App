import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.green.shade700,
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: Colors.green.shade300,
        disabledBackgroundColor: Colors.green.shade300,
        minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
        fixedSize: isFullWidth ? null : const Size(200, 56),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: textColor ?? Colors.white,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(
                    icon,
                    color: textColor ?? Colors.white,
                    size: 22,
                  ),
                ],
              ],
            ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: height ?? 56,
        child: button,
      );
    }
    return SizedBox(
      height: height ?? 56,
      child: button,
    );
  }
}