import 'package:flutter/material.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/neo_button.dart';
import '../../../shared/widgets/neo_card.dart';

class TutorialModal extends StatefulWidget {
  final String title;
  final List<String> steps;
  final VoidCallback onStart;
  final String lang;

  const TutorialModal({
    super.key,
    required this.title,
    required this.steps,
    required this.onStart,
    required this.lang,
  });

  @override
  State<TutorialModal> createState() => _TutorialModalState();
}

class _TutorialModalState extends State<TutorialModal> {
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: const BorderSide(color: AppTheme.black, width: 3.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.black),
                  onPressed: widget.onStart,
                ),
              ],
            ),
            const Divider(color: AppTheme.black, thickness: 2),
            const SizedBox(height: 16),
            NeoCard(
              backgroundColor: AppTheme.blue,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    "STEP ${_stepIndex + 1} OF ${widget.steps.length}",
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Icon(Icons.center_focus_strong, size: 56, color: AppTheme.white),
                  const SizedBox(height: 16),
                  Text(
                    widget.steps[_stepIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (_stepIndex > 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: NeoButton(
                        text: "Back",
                        backgroundColor: AppTheme.white,
                        textColor: AppTheme.black,
                        onPressed: () => setState(() => _stepIndex--),
                      ),
                    ),
                  ),
                Expanded(
                  child: NeoButton(
                    text: _stepIndex == widget.steps.length - 1 ? "Start Capture" : "Next Step",
                    backgroundColor: AppTheme.green,
                    onPressed: () {
                      if (_stepIndex < widget.steps.length - 1) {
                        setState(() => _stepIndex++);
                      } else {
                        widget.onStart();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
