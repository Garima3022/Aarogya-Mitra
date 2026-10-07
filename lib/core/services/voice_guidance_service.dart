import 'package:flutter/material.dart';

class VoiceGuidanceService extends ChangeNotifier {
  bool _isSpeaking = false;
  String _currentText = '';
  double _volume = 1.0;
  double _pitch = 1.0;
  double _rate = 0.5; // Optimized for clarity in rural healthcare
  String _languageCode = 'en';

  bool get isSpeaking => _isSpeaking;
  String get currentText => _currentText;
  double get volume => _volume;
  double get rate => _rate;

  VoiceGuidanceService() {
    _initTts();
  }

  void _initTts() {
    // Tts initialization hook (FlutterTts can be wired here)
  }

  Future<void> setLanguage(String langCode) async {
    _languageCode = langCode;
    notifyListeners();
  }

  Future<void> setSpeed(double newRate) async {
    _rate = newRate;
    notifyListeners();
  }

  Future<void> speak(String text, {bool force = false}) async {
    if (text.isEmpty) return;
    if (_isSpeaking && !force && _currentText == text) {
      // Debounce repetitive voice guidance
      return;
    }

    _currentText = text;
    _isSpeaking = true;
    notifyListeners();

    // Simulate speech playback cycle
    Future.delayed(const Duration(seconds: 3), () {
      _isSpeaking = false;
      notifyListeners();
    });
  }

  Future<void> stop() async {
    _isSpeaking = false;
    _currentText = '';
    notifyListeners();
  }

  Future<void> repeat() async {
    if (_currentText.isNotEmpty) {
      speak(_currentText, force: true);
    }
  }
}
