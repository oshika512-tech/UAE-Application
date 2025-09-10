import 'package:flutter/material.dart';
import 'package:meditation_center/presentation/components/introduction.text.dart';

class BottomText extends StatelessWidget {
  const BottomText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            IntroductionText.text(
              theme,
              "Click on the select images button to select an image",
              true,
            ),
            IntroductionText.text(
              theme,
              "You can select multiple images at once",
              true,
            ),
            IntroductionText.text(
              theme,
              "After selecting images, you can delete any image by clicking on the delete icon",
              true,
            ),
            IntroductionText.text(
              theme,
              "Add description about your post in the description field",
              true,
            ),
          ],
        ),
      ),
    );
  }
}
