import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/notice.card.dart';
import 'package:meditation_center/providers/post.with.users.provider.dart';
import 'package:provider/provider.dart';

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
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: RefreshIndicator(
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        onRefresh: _refreshPosts,
        child: Consumer(
          builder: (context, PostWithUsersProvider postWithUser, child) =>
              FutureBuilder(
            future: postWithUser.getPostsWithUsers(),
            builder: (context, snapshot) {
              // error getting user
              if (snapshot.hasError) {
                EasyLoading.dismiss();
                AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
              }
              // loading user data
              if (snapshot.connectionState == ConnectionState.waiting) {
                LoadingPopup.show('Logging...');
              }

              if (snapshot.hasData) {
                EasyLoading.dismiss();

                if (snapshot.data!.isEmpty) {
                  return EmptyAnimation(title: "No posts yet !");
                }

                final posts = snapshot.data as List<PostWithUsersModel>;

                return ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: posts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PostCard(
                      userName: posts[index].user.name,
                      userImage: posts[index].user.profileImage,
                      postUrlList: posts[index].post.images,
                      des: posts[index].post.description ?? "",
                      comments: posts[index].post.likes,
                      likes: posts[index].post.comments,
                      time: posts[index].post.dateTime,
                    );
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
