import 'package:flutter/material.dart';

/// App Constants for SEHAT VISION
class AppConstants {
  static const String appName = 'SEHAT VISION';
  static const String appSubtitle = 'AI-Assisted Early Screening for Everyone';
  static const String appVersion = '1.0.0 (Prototype)';
  
  // API Defaults
  static const String defaultApiBaseUrl = 'http://10.0.2.2:8000/api/v1'; // Android emulator localhost
  
  // Storage Keys
  static const String keyLanguage = 'selected_language';
  static const String keyVoiceEnabled = 'voice_enabled';
  static const String keyVoiceSpeed = 'voice_speed';
  static const String keyGuidedMode = 'guided_mode';
  static const String keyEasyMode = 'easy_mode';
  static const String keyAutoCapture = 'auto_capture';
  static const String keyHapticsEnabled = 'haptics_enabled';
  static const String keyDemoMode = 'demo_mode';
  static const String keyCaptureHistory = 'capture_history_v1';

  // Medical UX Disclaimer
  static const String medicalDisclaimer = 
      'This application is an AI-assisted early screening support tool for community healthcare settings. '
      'It does NOT provide a definitive medical diagnosis. All findings require clinical evaluation '
      'by a qualified medical professional.';
}
