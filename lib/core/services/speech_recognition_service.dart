import 'package:flutter/material.dart';

class SpeechRecognitionService extends ChangeNotifier {
  bool _isListening = false;
  String _recognizedText = '';
  double _soundLevel = 0.0;
  bool _isAvailable = true;

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  double get soundLevel => _soundLevel;
  bool get isAvailable => _isAvailable;

  Future<void> startListening({required Function(String text) onResult}) async {
    _isListening = true;
    _recognizedText = '';
    notifyListeners();

    // Simulated speech recognition for prototype voice input
    await Future.delayed(const Duration(seconds: 2));
    _recognizedText = "Patient Ramesh Kumar age 45 male diabetic 5 years";
    onResult(_recognizedText);

    _isListening = false;
    notifyListeners();
  }

  Future<void> stopListening() async {
    _isListening = false;
    notifyListeners();
  }

  void cancel() {
    _isListening = false;
    _recognizedText = '';
    notifyListeners();
  }
}
