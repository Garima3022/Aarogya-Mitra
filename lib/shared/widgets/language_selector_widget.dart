import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String currentLang;
  final Function(String langCode) onLanguageSelected;

  const LanguageSelectorWidget({
    super.key,
    required this.currentLang,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildOption('English', 'en'),
        const SizedBox(height: 10),
        _buildOption('हिन्दी (Hindi)', 'hi'),
        const SizedBox(height: 10),
        _buildOption('বাংলা (Bengali)', 'bn'),
      ],
    );
  }

  Widget _buildOption(String label, String langCode) {
    final isSelected = currentLang == langCode;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary : AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.black, width: 3.0),
        boxShadow: AppTheme.neoShadow(offset: isSelected ? 2.0 : 3.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onLanguageSelected(langCode),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? AppTheme.white : AppTheme.black,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppTheme.green, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
