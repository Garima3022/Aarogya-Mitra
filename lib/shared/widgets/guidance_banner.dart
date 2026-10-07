import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GuidanceBanner extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final IconData icon;

  const GuidanceBanner({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.black, width: 3.0),
        boxShadow: AppTheme.neoShadow(offset: 3.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: AppTheme.black, width: 2)),
            ),
            child: Icon(icon, color: AppTheme.black, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
