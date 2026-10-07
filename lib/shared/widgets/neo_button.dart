import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeoButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isFullWidth;
  final double shadowOffset;

  const NeoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppTheme.primary,
    this.textColor = AppTheme.white,
    this.isFullWidth = true,
    this.shadowOffset = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final btn = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: shadowOffset > 0
            ? AppTheme.neoShadow(offset: shadowOffset, shadowColor: AppTheme.black)
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            side: const BorderSide(color: AppTheme.black, width: AppTheme.borderThicknessThick),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
