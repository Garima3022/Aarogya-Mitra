enum SmartCaptureState {
  initializing,
  checking,
  tooFar,
  tooClose,
  lowLight,
  tooBright,
  blurDetected,
  targetNotCentered,
  targetNotVisible,
  glareDetected,
  holdSteady,
  ready,
  capturing,
  captured,
  error
}

class ImageQualityResult {
  final double brightnessScore; // 0.0 to 1.0
  final double sharpnessScore;  // 0.0 to 1.0 (Laplacian variance)
  final double distanceScore;   // 0.0 to 1.0
  final double positionScore;   // 0.0 to 1.0 (Centering)
  final double glareScore;      // 0.0 to 1.0
  final double stabilityScore;  // 0.0 to 1.0
  final double overallScore;    // 0 to 100%
  final SmartCaptureState status;
  final String instructionKey;
  final String voiceInstructionKey;

  const ImageQualityResult({
    required this.brightnessScore,
    required this.sharpnessScore,
    required this.distanceScore,
    required this.positionScore,
    required this.glareScore,
    required this.stabilityScore,
    required this.overallScore,
    required this.status,
    required this.instructionKey,
    required this.voiceInstructionKey,
  });

  factory ImageQualityResult.initial() {
    return const ImageQualityResult(
      brightnessScore: 0.8,
      sharpnessScore: 0.8,
      distanceScore: 0.8,
      positionScore: 0.8,
      glareScore: 0.9,
      stabilityScore: 0.8,
      overallScore: 82.0,
      status: SmartCaptureState.checking,
      instructionKey: 'checking',
      voiceInstructionKey: '',
    );
  }

  factory ImageQualityResult.ready() {
    return const ImageQualityResult(
      brightnessScore: 0.95,
      sharpnessScore: 0.92,
      distanceScore: 0.90,
      positionScore: 0.96,
      glareScore: 0.95,
      stabilityScore: 0.94,
      overallScore: 93.0,
      status: SmartCaptureState.ready,
      instructionKey: 'state_ready',
      voiceInstructionKey: 'v_ready',
    );
  }
}

class ImageQualityService {
  /// Evaluates frame quality metrics and determines capture state machine state
  ImageQualityResult analyzeFrameMock(SmartCaptureState forcedState) {
    switch (forcedState) {
      case SmartCaptureState.lowLight:
        return const ImageQualityResult(
          brightnessScore: 0.3,
          sharpnessScore: 0.8,
          distanceScore: 0.8,
          positionScore: 0.8,
          glareScore: 0.9,
          stabilityScore: 0.8,
          overallScore: 52.0,
          status: SmartCaptureState.lowLight,
          instructionKey: 'state_low_light',
          voiceInstructionKey: 'v_low_light',
        );
      case SmartCaptureState.tooFar:
        return const ImageQualityResult(
          brightnessScore: 0.8,
          sharpnessScore: 0.8,
          distanceScore: 0.3,
          positionScore: 0.7,
          glareScore: 0.9,
          stabilityScore: 0.8,
          overallScore: 58.0,
          status: SmartCaptureState.tooFar,
          instructionKey: 'state_too_far',
          voiceInstructionKey: 'v_too_far',
        );
      case SmartCaptureState.blurDetected:
        return const ImageQualityResult(
          brightnessScore: 0.8,
          sharpnessScore: 0.25,
          distanceScore: 0.8,
          positionScore: 0.8,
          glareScore: 0.9,
          stabilityScore: 0.3,
          overallScore: 48.0,
          status: SmartCaptureState.blurDetected,
          instructionKey: 'state_blur',
          voiceInstructionKey: 'v_blur',
        );
      case SmartCaptureState.targetNotCentered:
        return const ImageQualityResult(
          brightnessScore: 0.8,
          sharpnessScore: 0.85,
          distanceScore: 0.8,
          positionScore: 0.3,
          glareScore: 0.9,
          stabilityScore: 0.8,
          overallScore: 61.0,
          status: SmartCaptureState.targetNotCentered,
          instructionKey: 'state_off_center',
          voiceInstructionKey: 'v_off_center',
        );
      case SmartCaptureState.ready:
      default:
        return ImageQualityResult.ready();
    }
  }
}
