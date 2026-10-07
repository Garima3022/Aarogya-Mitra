import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/screening_result_model.dart';
import '../../../shared/widgets/guidance_banner.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/status_badge.dart';

class ScreeningResultScreen extends StatefulWidget {
  final ScreeningResultModel result;
  final String lang;
  final VoidCallback onNewScreening;

  const ScreeningResultScreen({
    super.key,
    required this.result,
    required this.lang,
    required this.onNewScreening,
  });

  @override
  State<ScreeningResultScreen> createState() => _ScreeningResultScreenState();
}

class _ScreeningResultScreenState extends State<ScreeningResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showHeatmap = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDR = widget.result.type == ScreeningType.diabeticRetinopathy;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppTranslations.getText('screening_result', widget.lang)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Demo Mode Warning Banner
              if (widget.result.isDemoResult)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GuidanceBanner(
                    title: AppTranslations.getText('demo_mode', widget.lang),
                    description: AppTranslations.getText('demo_banner_sub', widget.lang),
                    backgroundColor: AppTheme.warning,
                    icon: Icons.science,
                  ),
                ),

              // Screening Result Status Card
              NeoCard(
                backgroundColor: widget.result.status == 'Needs Clinical Review'
                    ? AppTheme.danger
                    : AppTheme.green,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(
                          label: isDR ? "RETINA SCREENING" : "ORAL SCREENING",
                          backgroundColor: AppTheme.black,
                          textColor: AppTheme.white,
                        ),
                        Text(
                          widget.result.screeningId,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.result.status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AppTranslations.getText('discuss_with_doctor', widget.lang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Explainable AI & Heatmap Viewer
              NeoCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Explainable AI Screening Overlay",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _showHeatmap = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_showHeatmap ? AppTheme.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  AppTranslations.getText('original_image', widget.lang),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !_showHeatmap ? AppTheme.white : AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _showHeatmap = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _showHeatmap ? AppTheme.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  AppTranslations.getText('ai_heatmap', widget.lang),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _showHeatmap ? AppTheme.white : AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Image Display Surface with Simulated Heatmap
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              isDR ? Icons.remove_red_eye : Icons.face,
                              size: 100,
                              color: AppTheme.primary,
                            ),
                          ),
                          if (_showHeatmap)
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.red.withOpacity(0.7),
                                      Colors.yellow.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              color: AppTheme.black,
                              child: Text(
                                _showHeatmap ? "GRAD-CAM HEATMAP OVERLAY" : "CAPTURED IMAGE",
                                style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      AppTranslations.getText('heatmap_desc', widget.lang),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Patient Summary & Clinical Findings
              NeoCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Patient & Findings Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Divider(color: AppTheme.black, thickness: 1.5),
                    Text("Patient: ${widget.result.patientName} (${widget.result.patientId})"),
                    Text("Age/Gender: ${widget.result.age} yrs • ${widget.result.gender}"),
                    const SizedBox(height: 8),
                    Text(
                      "Summary: ${widget.result.findingsSummary}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Export & Action Buttons
              Row(
                children: [
                  Expanded(
                    child: NeoButton(
                      text: AppTranslations.getText('save_report', widget.lang),
                      icon: Icons.save_alt,
                      backgroundColor: AppTheme.primary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Screening report saved locally.")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeoButton(
                      text: AppTranslations.getText('new_screening', widget.lang),
                      icon: Icons.refresh,
                      backgroundColor: AppTheme.green,
                      onPressed: widget.onNewScreening,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
