import 'package:flutter/material.dart';

import 'core/localization/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/patient/presentation/patient_form_screen.dart';
import 'features/screening/domain/screening_repository.dart';
import 'features/screening/presentation/screening_result_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/smart_capture/presentation/smart_capture_screen.dart';
import 'features/smart_capture/presentation/tutorial_modal.dart';
import 'shared/models/screening_result_model.dart';
import 'shared/widgets/desktop_mobile_frame.dart';

void main() {
  runApp(const SehatVisionApp());
}

class SehatVisionApp extends StatefulWidget {
  const SehatVisionApp({super.key});

  @override
  State<SehatVisionApp> createState() => _SehatVisionAppState();
}

class _SehatVisionAppState extends State<SehatVisionApp> {
  String _currentLanguage = 'en';
  bool _onboardingCompleted = false;

  void _setLanguage(String code) {
    setState(() => _currentLanguage = code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEHAT VISION',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: DesktopMobileFrame(
        child: !_onboardingCompleted
            ? OnboardingScreen(
                onComplete: () => setState(() => _onboardingCompleted = true),
              )
            : MainNavigationShell(
                currentLang: _currentLanguage,
                onLanguageChanged: _setLanguage,
              ),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final String currentLang;
  final Function(String code) onLanguageChanged;

  const MainNavigationShell({
    super.key,
    required this.currentLang,
    required this.onLanguageChanged,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final MockScreeningRepository _repo = MockScreeningRepository();
  List<ScreeningResultModel> _savedRecords = [];
  ScreeningResultModel? _selectedResult;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final list = await _repo.getSavedScreenings();
    setState(() => _savedRecords = list);
  }

  void _startFlow(ScreeningType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientFormScreen(
          lang: widget.currentLang,
          onContinue: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SmartCaptureScreen(
                  screeningType: type,
                  patientId: "DEMO-991",
                  patientName: "Ramesh Kumar",
                  patientAge: 45,
                  patientGender: "Male",
                  lang: widget.currentLang,
                  onCaptured: (path) async {
                    Navigator.pop(context); // pop capture
                    Navigator.pop(context); // pop patient form

                    // Run model inference simulation
                    final res = type == ScreeningType.diabeticRetinopathy
                        ? await _repo.analyzeRetinaImage(
                            imagePath: path,
                            patientId: "DEMO-991",
                            patientName: "Ramesh Kumar",
                            age: 45,
                            gender: "Male",
                          )
                        : await _repo.analyzeOralImage(
                            imagePath: path,
                            patientId: "DEMO-991",
                            patientName: "Ramesh Kumar",
                            age: 45,
                            gender: "Male",
                          );

                    setState(() {
                      _savedRecords.insert(0, res);
                      _selectedResult = res;
                    });

                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ScreeningResultScreen(
                            result: res,
                            lang: widget.currentLang,
                            onNewScreening: () {
                              Navigator.pop(ctx);
                              setState(() => _currentIndex = 0);
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openCoachTutorial() {
    showDialog(
      context: context,
      builder: (ctx) => TutorialModal(
        title: "Camera Coach Training",
        steps: const [
          "Ensure bright room lighting before positioning the patient.",
          "Hold the phone camera 10–15cm from target area.",
          "Wait for the Smart Coach GREEN border before auto-capture.",
        ],
        onStart: () => Navigator.pop(ctx),
        lang: widget.currentLang,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        lang: widget.currentLang,
        onStartDR: () => _startFlow(ScreeningType.diabeticRetinopathy),
        onStartOral: () => _startFlow(ScreeningType.oralLesion),
        onOpenLearnCoach: _openCoachTutorial,
        recentScreenings: _savedRecords,
        onSelectHistoryItem: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ScreeningResultScreen(
                result: item,
                lang: widget.currentLang,
                onNewScreening: () => Navigator.pop(ctx),
              ),
            ),
          );
        },
      ),
      HistoryScreen(
        records: _savedRecords,
        lang: widget.currentLang,
        onSelectRecord: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ScreeningResultScreen(
                result: item,
                lang: widget.currentLang,
                onNewScreening: () => Navigator.pop(ctx),
              ),
            ),
          );
        },
      ),
      SettingsScreen(
        lang: widget.currentLang,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.black, width: 3.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: AppTheme.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.black.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppTranslations.getText('nav_home', widget.currentLang),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              activeIcon: const Icon(Icons.history_toggle_off),
              label: AppTranslations.getText('nav_history', widget.currentLang),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: AppTranslations.getText('nav_settings', widget.currentLang),
            ),
          ],
        ),
      ),
    );
  }
}
