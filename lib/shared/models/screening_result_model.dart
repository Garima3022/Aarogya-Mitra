enum ScreeningType { diabeticRetinopathy, oralLesion }

class ScreeningResultModel {
  final String screeningId;
  final String patientId;
  final String patientName;
  final int age;
  final String gender;
  final ScreeningType type;
  final DateTime timestamp;
  final String status;            // e.g., "Needs Clinical Review" or "Screening Negative"
  final String riskCategory;       // e.g., "Moderate Risk", "Low Risk", "High Risk"
  final double? confidence;       // 0.0 - 1.0 (Only if calibrated model returns it)
  final String imagePath;
  final String? heatmapPath;
  final String findingsSummary;
  final bool isDemoResult;

  const ScreeningResultModel({
    required this.screeningId,
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.type,
    required this.timestamp,
    required this.status,
    required this.riskCategory,
    this.confidence,
    required this.imagePath,
    this.heatmapPath,
    required this.findingsSummary,
    this.isDemoResult = true,
  });
}
