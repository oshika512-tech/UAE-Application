import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/datetime/datetime.calculate.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PostCardUserInfo extends StatelessWidget {
  final String userName;
  final String userImage;
  final DateTime time;
  final String userId;

  const PostCardUserInfo({
    super.key,
    required this.userName,
    required this.userImage,
    required this.time,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // navigate to user profile
            context.push(
              '/profile',
              extra: userId,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                userImage != "" ? userImage : AppData.baseUserUrl,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 2),
            Text(
              DatetimeCalculate.timeAgo(time),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.gray, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
