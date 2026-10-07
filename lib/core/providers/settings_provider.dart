import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _voiceGuidanceEnabled = true;
  double _voiceSpeed = 0.5;
  bool _guidedMode = true;
  bool _easyMode = false;
  bool _autoCapture = true;
  bool _hapticsEnabled = true;
  bool _demoMode = true;

  bool get voiceGuidanceEnabled => _voiceGuidanceEnabled;
  double get voiceSpeed => _voiceSpeed;
  bool get guidedMode => _guidedMode;
  bool get easyMode => _easyMode;
  bool get autoCapture => _autoCapture;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get demoMode => _demoMode;

  void toggleVoiceGuidance(bool val) {
    _voiceGuidanceEnabled = val;
    notifyListeners();
  }

  void setVoiceSpeed(double speed) {
    _voiceSpeed = speed;
    notifyListeners();
  }

  void toggleGuidedMode(bool val) {
    _guidedMode = val;
    notifyListeners();
  }

  void toggleEasyMode(bool val) {
    _easyMode = val;
    notifyListeners();
  }

  void toggleAutoCapture(bool val) {
    _autoCapture = val;
    notifyListeners();
  }

  void toggleHaptics(bool val) {
    _hapticsEnabled = val;
    notifyListeners();
  }

  void toggleDemoMode(bool val) {
    _demoMode = val;
    notifyListeners();
  }
}
