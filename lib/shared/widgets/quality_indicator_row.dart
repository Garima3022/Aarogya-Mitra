import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class QualityIndicatorRow extends StatelessWidget {
  final String label;
  final double score; // 0.0 to 1.0
  final String statusText;

  const QualityIndicatorRow({
    super.key,
    required this.label,
    required this.score,
    required this.statusText,
  });

  Color _getStatusColor() {
    if (score >= 0.85) return AppTheme.green;
    if (score >= 0.60) return AppTheme.warning;
    return AppTheme.danger;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.black, width: 1.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
          Text(
            statusText,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: statusColor == AppTheme.green ? AppTheme.black : statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
