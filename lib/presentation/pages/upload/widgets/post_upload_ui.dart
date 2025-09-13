import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:provider/provider.dart';

class PostUploadUi extends StatefulWidget {
  const PostUploadUi({super.key});

  @override
  State<PostUploadUi> createState() => _PostUploadUiState();
}

class _PostUploadUiState extends State<PostUploadUi> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Consumer<PostProvider>(
        builder: (context, provider, child) {
           
          if (provider.isDone) {
            Future.microtask(() {
              Navigator.of(context).pop();
            });
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Uploading...",
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${provider.uploadProgress.toInt()} %",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: provider.uploadProgress / 100,
                color: theme.primaryColor,
                minHeight: 5,
                backgroundColor: AppColors.secondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ],
          );
        },
      ),
    );
  }
}
