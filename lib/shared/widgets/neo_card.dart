import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = AppTheme.surfaceCard,
    this.borderColor = AppTheme.black,
    this.borderWidth = AppTheme.borderThicknessThick,
    this.shadowOffset = 4.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadowOffset > 0
            ? AppTheme.neoShadow(offset: shadowOffset, shadowColor: borderColor)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
