import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';

class ConfirmOverlay extends StatelessWidget {
  final String message;
  final String yesText;
  final String noText;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final bool dismissible;

  const ConfirmOverlay({
    super.key,
    required this.message,
    required this.onYes,
    required this.onNo,
    this.yesText = 'Yes',
    this.noText = 'No',
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black54,
          dismissible: dismissible,
          onDismiss: dismissible ? onNo : null,
        ),
        Center(
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 150),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  color: AppColors.myBeige,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: onNo,
                              child: Text(noText),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.myRed,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: onYes,
                              child: Text(yesText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}