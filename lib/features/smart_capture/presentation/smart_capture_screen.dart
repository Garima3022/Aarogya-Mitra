import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/services/image_quality_service.dart';
import '../../../core/services/voice_guidance_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/screening_result_model.dart';
import '../../../shared/widgets/guidance_banner.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/quality_indicator_row.dart';
import '../../../shared/widgets/voice_button.dart';
import 'tutorial_modal.dart';

class SmartCaptureScreen extends StatefulWidget {
  final ScreeningType screeningType;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String lang;
  final Function(String capturedPath) onCaptured;

  const SmartCaptureScreen({
    super.key,
    required this.screeningType,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.lang,
    required this.onCaptured,
  });

  @override
  State<SmartCaptureScreen> createState() => _SmartCaptureScreenState();
}

class _SmartCaptureScreenState extends State<SmartCaptureScreen> {
  final ImageQualityService _qualityService = ImageQualityService();
  final VoiceGuidanceService _voiceService = VoiceGuidanceService();

  SmartCaptureState _forcedState = SmartCaptureState.lowLight;
  bool _torchOn = false;
  bool _autoCaptureOn = true;
  int _countdown = 3;
  Timer? _autoTimer;
  bool _showAdvancedScore = false;

  @override
  void initState() {
    super.initState();
    _triggerVoiceGuidance();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _voiceService.dispose();
    super.dispose();
  }

  void _triggerVoiceGuidance() {
    final res = _qualityService.analyzeFrameMock(_forcedState);
    if (res.voiceInstructionKey.isNotEmpty) {
      final text = AppTranslations.getText(res.voiceInstructionKey, widget.lang);
      _voiceService.speak(text);
    }
  }

  void _cycleQualityState() {
    setState(() {
      if (_forcedState == SmartCaptureState.lowLight) {
        _forcedState = SmartCaptureState.tooFar;
      } else if (_forcedState == SmartCaptureState.tooFar) {
        _forcedState = SmartCaptureState.blurDetected;
      } else if (_forcedState == SmartCaptureState.blurDetected) {
        _forcedState = SmartCaptureState.targetNotCentered;
      } else if (_forcedState == SmartCaptureState.targetNotCentered) {
        _forcedState = SmartCaptureState.ready;
        _startAutoCaptureCountdown();
      } else {
        _forcedState = SmartCaptureState.lowLight;
        _autoTimer?.cancel();
      }
    });
    _triggerVoiceGuidance();
  }

  void _startAutoCaptureCountdown() {
    _autoTimer?.cancel();
    if (!_autoCaptureOn) return;

    setState(() => _countdown = 3);
    _autoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _captureNow();
      }
    });
  }

  void _captureNow() {
    _voiceService.speak("Captured!");
    widget.onCaptured("assets/sample_data/captured_sample.jpg");
  }

  void _showTutorial() {
    final steps = widget.screeningType == ScreeningType.diabeticRetinopathy
        ? [
            "Position the patient comfortably in a dimly lit room.",
            "Ask the patient to look straight at the target marker.",
            "Align the camera lens with the pupil until the retina is visible.",
            "Hold steady until the auto-capture indicator turns GREEN."
          ]
        : [
            "Ask the patient to open their mouth wide in bright light.",
            "Center the oral cavity lesion inside the red camera frame.",
            "Ensure lens is clear of saliva moisture and distance is 10-15 cm.",
            "Hold steady for 3 seconds for auto-capture."
          ];

    showDialog(
      context: context,
      builder: (ctx) => TutorialModal(
        title: widget.screeningType == ScreeningType.diabeticRetinopathy
            ? "Retinal Smart Capture Tutorial"
            : "Oral Lesion Smart Capture Tutorial",
        steps: steps,
        lang: widget.lang,
        onStart: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qualityRes = _qualityService.analyzeFrameMock(_forcedState);
    final isDR = widget.screeningType == ScreeningType.diabeticRetinopathy;

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Camera Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    isDR ? "DR Smart Capture" : "Oral Smart Capture",
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      VoiceButton(
                        label: "Voice",
                        onPressed: _triggerVoiceGuidance,
                        isSpeaking: _voiceService.isSpeaking,
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline, color: AppTheme.white),
                        onPressed: _showTutorial,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Live Camera View Surface
            Expanded(
              child: Stack(
                children: [
                  // Camera Background Simulation
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF1E293B),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isDR ? Icons.remove_red_eye : Icons.face,
                            size: 140,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "LIVE CAMERA STREAM",
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Target Box Overlay
                  Center(
                    child: Container(
                      width: isDR ? 220 : 260,
                      height: isDR ? 220 : 220,
                      decoration: BoxDecoration(
                        shape: isDR ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius: isDR ? null : BorderRadius.circular(16),
                        border: Border.all(
                          color: _forcedState == SmartCaptureState.ready
                              ? AppTheme.green
                              : AppTheme.danger,
                          width: 4.0,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(4),
                          color: AppTheme.black,
                          child: Text(
                            isDR ? "RETINA TARGET" : "LESION TARGET",
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Real-time Guidance Banner Overlay
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: GuidanceBanner(
                      title: AppTranslations.getText(qualityRes.instructionKey, widget.lang),
                      description: AppTranslations.getText('${qualityRes.instructionKey}_desc', widget.lang),
                      backgroundColor: _forcedState == SmartCaptureState.ready
                          ? AppTheme.green
                          : (_forcedState == SmartCaptureState.lowLight || _forcedState == SmartCaptureState.tooFar
                              ? AppTheme.warning
                              : AppTheme.danger),
                      icon: _forcedState == SmartCaptureState.ready
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                    ),
                  ),

                  // Interactive Coach State Simulator Pill (For Testing Quality Machine)
                  Positioned(
                    top: 100,
                    right: 16,
                    child: GestureDetector(
                      onTap: _cycleQualityState,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.blue,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.white, width: 2),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.touch_app, color: AppTheme.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              "Simulate Quality Issue",
                              style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Ready Auto-Capture Countdown Indicator
                  if (_forcedState == SmartCaptureState.ready && _autoCaptureOn)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.black.withOpacity(0.85),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.green, width: 4),
                        ),
                        child: Text(
                          "$_countdown",
                          style: const TextStyle(
                            color: AppTheme.green,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Quality Dashboard Controls (Medical Neo-Brutalist Dashboard)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quality Indicators
                  NeoCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _forcedState == SmartCaptureState.ready
                                  ? "🟢 READY TO CAPTURE"
                                  : "🟡 ADJUST CAMERA",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppTheme.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _showAdvancedScore = !_showAdvancedScore),
                              child: Text(
                                _showAdvancedScore ? "Hide Metrics" : "Quality: ${qualityRes.overallScore.toInt()}%",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppTheme.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppTheme.black, thickness: 1.5),
                        QualityIndicatorRow(
                          label: "Lighting",
                          score: qualityRes.brightnessScore,
                          statusText: qualityRes.brightnessScore >= 0.8 ? "Good" : "Low Light",
                        ),
                        QualityIndicatorRow(
                          label: "Distance",
                          score: qualityRes.distanceScore,
                          statusText: qualityRes.distanceScore >= 0.8 ? "Good" : "Move Closer",
                        ),
                        QualityIndicatorRow(
                          label: "Focus / Blur",
                          score: qualityRes.sharpnessScore,
                          statusText: qualityRes.sharpnessScore >= 0.8 ? "Clear" : "Blurry",
                        ),
                        if (_showAdvancedScore) ...[
                          QualityIndicatorRow(
                            label: "Position / Centering",
                            score: qualityRes.positionScore,
                            statusText: qualityRes.positionScore >= 0.8 ? "Centered" : "Off-Center",
                          ),
                          QualityIndicatorRow(
                            label: "Stability",
                            score: qualityRes.stabilityScore,
                            statusText: qualityRes.stabilityScore >= 0.8 ? "Steady" : "Moving",
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Capture Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Torch Switch
                      IconButton(
                        icon: Icon(
                          _torchOn ? Icons.flash_on : Icons.flash_off,
                          color: AppTheme.black,
                          size: 28,
                        ),
                        onPressed: () => setState(() => _torchOn = !_torchOn),
                      ),

                      // Manual / Auto Trigger Capture Button
                      GestureDetector(
                        onTap: _captureNow,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: _forcedState == SmartCaptureState.ready
                                ? AppTheme.green
                                : AppTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.black, width: 4),
                            boxShadow: AppTheme.neoShadow(offset: 4),
                          ),
                          child: const Icon(Icons.camera_alt, color: AppTheme.white, size: 34),
                        ),
                      ),

                      // Auto Capture Switch
                      IconButton(
                        icon: Icon(
                          _autoCaptureOn ? Icons.autorenew : Icons.touch_app,
                          color: _autoCaptureOn ? AppTheme.blue : AppTheme.black,
                          size: 28,
                        ),
                        onPressed: () => setState(() => _autoCaptureOn = !_autoCaptureOn),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
