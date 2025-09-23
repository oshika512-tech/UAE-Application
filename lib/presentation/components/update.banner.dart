import 'package:flutter/material.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';

class UpdateBanner {
  static void showUpdateBanner(
    BuildContext context,
    VoidCallback onTap
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                Text(
                  "Update Available !",
                  style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "A new app version is available. Update to the latest version for the best experience.",
                  style: Theme.of(dialogContext).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AppButtons(
                  width: 200,
                  height: 40,
                  icon: Icons.update,
                  text: "Update Now",
                  isPrimary: true,
                  onTap: onTap,
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    });
  }
}
