import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/language_selector_widget.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/status_badge.dart';

class SettingsScreen extends StatelessWidget {
  final String lang;
  final Function(String code) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.lang,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider();
    final connectivity = ConnectivityService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppTranslations.getText('nav_settings', lang)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Selection Card
              NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText('select_language', lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LanguageSelectorWidget(
                      currentLang: lang,
                      onLanguageSelected: onLanguageChanged,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Operational Modes Switch Card
              NeoCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Voice Guidance (TTS)", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Announce active camera instructions"),
                      value: settings.voiceGuidanceEnabled,
                      activeColor: AppTheme.green,
                      onChanged: (val) => settings.toggleVoiceGuidance(val),
                    ),
                    const Divider(color: AppTheme.black),
                    SwitchListTile(
                      title: const Text("Guided Screening Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Step-by-step tutorial prompts for new health workers"),
                      value: settings.guidedMode,
                      activeColor: AppTheme.green,
                      onChanged: (val) => settings.toggleGuidedMode(val),
                    ),
                    const Divider(color: AppTheme.black),
                    SwitchListTile(
                      title: const Text("Easy Mode (High Contrast / Large Text)", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Simplified interface for low digital literacy"),
                      value: settings.easyMode,
                      activeColor: AppTheme.green,
                      onChanged: (val) => settings.toggleEasyMode(val),
                    ),
                    const Divider(color: AppTheme.black),
                    SwitchListTile(
                      title: const Text("Auto Capture", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Automatically take photo when quality criteria is met"),
                      value: settings.autoCapture,
                      activeColor: AppTheme.green,
                      onChanged: (val) => settings.toggleAutoCapture(val),
                    ),
                    const Divider(color: AppTheme.black),
                    SwitchListTile(
                      title: const Text("Demo Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Use mock AI models without backend server"),
                      value: settings.demoMode,
                      activeColor: AppTheme.warning,
                      onChanged: (val) => settings.toggleDemoMode(val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy & Medical Compliance Disclaimer Card
              NeoCard(
                backgroundColor: AppTheme.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.security, color: AppTheme.primary),
                        SizedBox(width: 8),
                        Text(
                          "Privacy & Medical Standards",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "🔒 Data stays on this device. No automatic cloud uploads occur. Patient information processed locally.",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: AppTheme.background,
                      child: Text(
                        AppConstants.medicalDisclaimer,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "SEHAT VISION v1.0.0 (Build 2026)",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
