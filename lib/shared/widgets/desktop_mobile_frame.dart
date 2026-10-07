import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DesktopMobileFrame extends StatelessWidget {
  final Widget child;
  final double targetWidth;

  const DesktopMobileFrame({
    super.key,
    required this.child,
    this.targetWidth = 415.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F172A),
            body: Center(
              child: Container(
                width: targetWidth,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.black, width: 4.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: child,
                ),
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
