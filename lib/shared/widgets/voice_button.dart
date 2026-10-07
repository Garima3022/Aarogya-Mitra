import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSpeaking;
  final String label;

  const VoiceButton({
    super.key,
    required this.onPressed,
    this.isSpeaking = false,
    this.label = 'Repeat',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSpeaking ? AppTheme.warning : AppTheme.blue,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.black, width: 2.0),
        boxShadow: AppTheme.neoShadow(offset: 2.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSpeaking ? Icons.volume_up : Icons.record_voice_over,
                  color: AppTheme.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
