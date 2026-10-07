import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/providers/patient_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/voice_button.dart';

class PatientFormScreen extends StatefulWidget {
  final String lang;
  final VoidCallback onContinue;

  const PatientFormScreen({
    super.key,
    required this.lang,
    required this.onContinue,
  });

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _notesController;
  bool _isListening = false;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    final patient = PatientProvider();
    _idController = TextEditingController(text: patient.patientId);
    _nameController = TextEditingController(text: patient.patientName.isEmpty ? 'Ramesh Kumar' : patient.patientName);
    _ageController = TextEditingController(text: patient.patientAge.toString());
    _notesController = TextEditingController(text: patient.notes);
  }

  void _fillWithVoice() async {
    setState(() => _isListening = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isListening = false;
      _nameController.text = "Ramesh Kumar";
      _ageController.text = "45";
      _notesController.text = "6 year history of Type 2 Diabetes";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppTranslations.getText('patient_info', widget.lang)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voice Fill Prompt Banner
              NeoCard(
                backgroundColor: _isListening ? AppTheme.warning : AppTheme.blue,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: AppTheme.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isListening
                                ? AppTranslations.getText('listening', widget.lang)
                                : AppTranslations.getText('fill_with_voice', widget.lang),
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Speak name, age, and symptoms clearly",
                            style: TextStyle(color: AppTheme.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    VoiceButton(
                      label: "🎤 Speak",
                      onPressed: _fillWithVoice,
                      isSpeaking: _isListening,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Fields
              _buildFieldLabel(AppTranslations.getText('patient_id', widget.lang)),
              const SizedBox(height: 6),
              _buildTextField(_idController, readOnly: true),

              const SizedBox(height: 16),

              _buildFieldLabel(AppTranslations.getText('patient_name', widget.lang)),
              const SizedBox(height: 6),
              _buildTextField(_nameController, hint: "Enter full name"),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(AppTranslations.getText('patient_age', widget.lang)),
                        const SizedBox(height: 6),
                        _buildTextField(_ageController, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(AppTranslations.getText('patient_gender', widget.lang)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            border: Border.all(color: AppTheme.black, width: 2.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              isExpanded: true,
                              items: ['Male', 'Female', 'Other']
                                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedGender = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildFieldLabel(AppTranslations.getText('notes', widget.lang)),
              const SizedBox(height: 6),
              _buildTextField(_notesController, maxLines: 3, hint: "Enter diabetes history or symptoms"),

              const SizedBox(height: 30),

              NeoButton(
                text: AppTranslations.getText('continue_screening', widget.lang),
                icon: Icons.arrow_forward,
                backgroundColor: AppTheme.green,
                onPressed: () {
                  PatientProvider().updatePatient(
                    id: _idController.text,
                    name: _nameController.text,
                    age: int.tryParse(_ageController.text) ?? 40,
                    gender: _selectedGender,
                    notes: _notesController.text,
                  );
                  widget.onContinue();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppTheme.black,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool readOnly = false,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? const Color(0xFFE2E8F0) : AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppTheme.black, width: 2.0),
        boxShadow: AppTheme.neoShadow(offset: 2.0),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
