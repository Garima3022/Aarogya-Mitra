import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/screening_result_model.dart';
import '../../../shared/widgets/neo_card.dart';
import '../../../shared/widgets/status_badge.dart';

class HistoryScreen extends StatelessWidget {
  final List<ScreeningResultModel> records;
  final String lang;
  final Function(ScreeningResultModel item) onSelectRecord;

  const HistoryScreen({
    super.key,
    required this.records,
    required this.lang,
    required this.onSelectRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppTranslations.getText('recent_screenings', lang)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: records.isEmpty
            ? Center(
                child: Text(
                  AppTranslations.getText('no_recent', lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];
                  final isDR = item.type == ScreeningType.diabeticRetinopathy;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: NeoCard(
                      onTap: () => onSelectRecord(item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(
                                label: isDR ? "RETINA" : "ORAL",
                                backgroundColor: isDR ? AppTheme.primary : AppTheme.blue,
                              ),
                              Text(
                                item.screeningId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.patientName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text("Patient ID: ${item.patientId} • Age ${item.age}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                item.status == 'Needs Clinical Review'
                                    ? Icons.warning_amber
                                    : Icons.check_circle_outline,
                                color: item.status == 'Needs Clinical Review'
                                    ? AppTheme.danger
                                    : AppTheme.green,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: item.status == 'Needs Clinical Review'
                                      ? AppTheme.danger
                                      : AppTheme.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
