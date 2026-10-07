import 'package:flutter/material.dart';

class PatientProvider extends ChangeNotifier {
  String _patientId = 'DEMO-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  String _patientName = '';
  int _patientAge = 40;
  String _patientGender = 'Male';
  int _diabetesYears = 0;
  String _notes = '';

  String get patientId => _patientId;
  String get patientName => _patientName;
  int get patientAge => _patientAge;
  String get patientGender => _patientGender;
  int get diabetesYears => _diabetesYears;
  String get notes => _notes;

  void updatePatient({
    String? id,
    String? name,
    int? age,
    String? gender,
    int? diabetesYears,
    String? notes,
  }) {
    if (id != null) _patientId = id;
    if (name != null) _patientName = name;
    if (age != null) _patientAge = age;
    if (gender != null) _patientGender = gender;
    if (diabetesYears != null) _diabetesYears = diabetesYears;
    if (notes != null) _notes = notes;
    notifyListeners();
  }

  void reset() {
    _patientId = 'DEMO-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _patientName = '';
    _patientAge = 40;
    _patientGender = 'Male';
    _diabetesYears = 0;
    _notes = '';
    notifyListeners();
  }
}
