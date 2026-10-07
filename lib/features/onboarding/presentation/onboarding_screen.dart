import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/language_selector_widget.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final langProvider = LanguageProvider();
    final lang = langProvider.currentLanguage;

    final pages = [
      _buildPage(
        icon: Icons.health_and_safety_outlined,
        title: "Screen Earlier",
        description: "AI-assisted early screening designed for community health workers and rural clinics.",
        color: AppTheme.blue,
      ),
      _buildPage(
        icon: Icons.camera_enhance_outlined,
        title: "Capture with Confidence",
        description: "Your live Smart Camera Coach guides you on lighting, focus, and positioning step-by-step.",
        color: AppTheme.green,
      ),
      _buildPage(
        icon: Icons.signal_wifi_off_outlined,
        title: "Works 100% Offline",
        description: "Designed specifically for remote areas without internet or cellular connectivity.",
        color: AppTheme.primary,
      ),
      _buildLanguagePage(lang),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslations.getText('app_title', lang),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                    ),
                  ),
                  if (_currentPage < 3)
                    TextButton(
                      onPressed: () => _pageController.jumpToPage(3),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: AppTheme.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  children: pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppTheme.primary : AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppTheme.black, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              NeoButton(
                text: _currentPage == 3 ? "Start Screening" : "Next",
                icon: _currentPage == 3 ? Icons.play_arrow : Icons.arrow_forward,
                onPressed: () {
                  if (_currentPage < 3) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    widget.onComplete();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeoCard(
            backgroundColor: color,
            padding: const EdgeInsets.all(24),
            child: Icon(icon, size: 64, color: AppTheme.white),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePage(String currentLang) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.language, size: 64, color: AppTheme.primary),
        const SizedBox(height: 16),
        const Text(
          "Choose Language",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Select your preferred working language:",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        LanguageSelectorWidget(
          currentLang: currentLang,
          onLanguageSelected: (code) {
            setState(() {});
          },
        ),
      ],
    );
  }
}
