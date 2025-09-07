import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class IntroductionText {
  static Widget text(
    ThemeData theme,
    String text,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: Icon(Icons.do_not_disturb_on,
                size: 14, color:isDark ? AppColors.textColor : AppColors.whiteColor),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall!
                  .copyWith( color:isDark ? AppColors.textColor : AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}