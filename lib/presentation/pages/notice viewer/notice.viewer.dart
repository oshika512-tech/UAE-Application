import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/shimmer/notice.viewer.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/notice.model.dart';
import 'package:meditation_center/providers/notice.provider.dart';
import 'package:provider/provider.dart';

class NoticeViewer extends StatelessWidget {
  final String noticeID;
  const NoticeViewer({
    super.key,
    required this.noticeID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Notice',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
                fontSize: 20,
              ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, NoticeProvider provider, child) => FutureBuilder(
            future: provider.getNoticeByID(noticeID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const NoticeViewerShimmer();
              }

              if (snapshot.hasError) {
                AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
              }
              if (snapshot.hasData) {
                final notice = snapshot.data as NoticeModel;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notice.title,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      CachedNetworkImage(
                        imageUrl: notice.mainImage,
                        cacheKey: notice.mainImage,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(notice.body,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                );
              }
              return const NoticeViewerShimmer();
            },
          ),
        ),
      ),
    );
  }
}
