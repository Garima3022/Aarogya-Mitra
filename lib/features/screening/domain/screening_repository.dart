import '../../../shared/models/screening_result_model.dart';

abstract class ScreeningRepository {
  Future<ScreeningResultModel> analyzeRetinaImage({
    required String imagePath,
    required String patientId,
    required String patientName,
    required int age,
    required String gender,
    String? eyeSide,
  });

  Future<ScreeningResultModel> analyzeOralImage({
    required String imagePath,
    required String patientId,
    required String patientName,
    required int age,
    required String gender,
  });

  Future<List<ScreeningResultModel>> getSavedScreenings();
}

class MockScreeningRepository implements ScreeningRepository {
  @override
  Future<ScreeningResultModel> analyzeRetinaImage({
    required String imagePath,
    required String patientId,
    required String patientName,
    required int age,
    required String gender,
    String? eyeSide,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate AI model inference
    return ScreeningResultModel(
      screeningId: 'DR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      patientId: patientId,
      patientName: patientName,
      age: age,
      gender: gender,
      type: ScreeningType.diabeticRetinopathy,
      timestamp: DateTime.now(),
      status: 'Needs Clinical Review',
      riskCategory: 'Potential DR Finding',
      confidence: null, // Avoid claiming fake calibrated confidence
      imagePath: imagePath,
      heatmapPath: imagePath, // Demo heatmap overlay
      findingsSummary: 'Possible microaneurysms detected in lower nasal quadrant. Clinical fundus examination required.',
      isDemoResult: true,
    );
  }

  @override
  Future<ScreeningResultModel> analyzeOralImage({
    required String imagePath,
    required String patientId,
    required String patientName,
    required int age,
    required String gender,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return ScreeningResultModel(
      screeningId: 'OR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      patientId: patientId,
      patientName: patientName,
      age: age,
      gender: gender,
      type: ScreeningType.oralLesion,
      timestamp: DateTime.now(),
      status: 'Needs Clinical Review',
      riskCategory: 'Potential Mucosal Finding',
      confidence: null,
      imagePath: imagePath,
      heatmapPath: imagePath,
      findingsSummary: 'Erythematous region detected on lateral tongue margin. Specialist oral mucosa evaluation advised.',
      isDemoResult: true,
    );
  }

  @override
  Future<List<ScreeningResultModel>> getSavedScreenings() async {
    return [
      ScreeningResultModel(
        screeningId: 'DR-88912',
        patientId: 'DEMO-101',
        patientName: 'Ramesh Kumar',
        age: 45,
        gender: 'Male',
        type: ScreeningType.diabeticRetinopathy,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'Needs Clinical Review',
        riskCategory: 'Potential Retinal Finding',
        imagePath: 'assets/sample_data/sample_retina.jpg',
        findingsSummary: 'Fundus screening flagged potential vascular irregularity.',
        isDemoResult: true,
      ),
      ScreeningResultModel(
        screeningId: 'OR-44219',
        patientId: 'DEMO-102',
        patientName: 'Sunita Devi',
        age: 52,
        gender: 'Female',
        type: ScreeningType.oralLesion,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Screening Negative',
        riskCategory: 'Low Risk',
        imagePath: 'assets/sample_data/sample_oral.jpg',
        findingsSummary: 'Normal mucosa appearance. No urgent lesion detected.',
        isDemoResult: true,
      ),
    ];
  }
}
