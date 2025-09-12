import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/notice.card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshPosts() async {
    //TODO : refresh posts
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: RefreshIndicator(
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        onRefresh: _refreshPosts,
        child: ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const NoticeCard();
          },
        ),
      ),
    );
  }
}
