import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/screening_result_model.dart';
import '../../../shared/widgets/guidance_banner.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/status_badge.dart';

class HomeScreen extends StatelessWidget {
  final String lang;
  final VoidCallback onStartDR;
  final VoidCallback onStartOral;
  final VoidCallback onOpenLearnCoach;
  final List<ScreeningResultModel> recentScreenings;
  final Function(ScreeningResultModel item) onSelectHistoryItem;

  const HomeScreen({
    super.key,
    required this.lang,
    required this.onStartDR,
    required this.onStartOral,
    required this.onOpenLearnCoach,
    required this.recentScreenings,
    required this.onSelectHistoryItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.remove_red_eye_outlined, color: AppTheme.primary, size: 28),
            const SizedBox(width: 8),
            Text(AppTranslations.getText('app_title', lang)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: StatusBadge(
              label: AppTranslations.getText('offline_ready', lang),
              backgroundColor: AppTheme.green,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle & Status Banner
              Text(
                AppTranslations.getText('app_subtitle', lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 16),

              // Demo Mode Badge Banner
              GuidanceBanner(
                title: AppTranslations.getText('demo_mode', lang),
                description: AppTranslations.getText('demo_banner_sub', lang),
                backgroundColor: AppTheme.blue,
                icon: Icons.lightbulb_outline,
              ),

              const SizedBox(height: 24),

              // START SCREENING SECTION
              Text(
                AppTranslations.getText('start_screening', lang),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.black,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              // CARD 1: Diabetic Retinopathy Screening
              NeoCard(
                backgroundColor: AppTheme.surfaceCard,
                onTap: onStartDR,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: const Text("👁", style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.getText('dr_title', lang),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppTranslations.getText('dr_sub', lang),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Start Screening",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.blue,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16, color: AppTheme.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // CARD 2: Oral Lesion Screening
              NeoCard(
                backgroundColor: AppTheme.surfaceCard,
                onTap: onStartOral,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: const Text("👄", style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.getText('oral_title', lang),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppTranslations.getText('oral_sub', lang),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Start Screening",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.blue,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16, color: AppTheme.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CAPTURE COACH BANNER CARD
              NeoCard(
                backgroundColor: AppTheme.warning,
                onTap: onOpenLearnCoach,
                child: Row(
                  children: [
                    const Icon(Icons.school, size: 40, color: AppTheme.black),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.getText('capture_coach', lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.black,
                            ),
                          ),
                          Text(
                            AppTranslations.getText('capture_coach_sub', lang),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    NeoButton(
                      text: AppTranslations.getText('learn_button', lang),
                      isFullWidth: false,
                      backgroundColor: AppTheme.black,
                      textColor: AppTheme.white,
                      onPressed: onOpenLearnCoach,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // RECENT SCREENINGS SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslations.getText('recent_screenings', lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (recentScreenings.isEmpty)
                Text(
                  AppTranslations.getText('no_recent', lang),
                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                )
              else
                ...recentScreenings.take(2).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: NeoCard(
                          onTap: () => onSelectHistoryItem(item),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.patientName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${item.type == ScreeningType.diabeticRetinopathy ? 'DR' : 'Oral'} • ${item.screeningId}",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              StatusBadge(
                                label: item.status == 'Needs Clinical Review' ? 'Review' : 'Negative',
                                backgroundColor: item.status == 'Needs Clinical Review'
                                    ? AppTheme.danger
                                    : AppTheme.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
