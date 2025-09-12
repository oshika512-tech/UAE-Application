import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<PostWithUsersModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    final provider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    _postsFuture = provider.getAllPosts();
  }

  Future<void> _refreshPosts() async {
    try {
      LoadingPopup.show("Refreshing posts...");
      _loadPosts(); // update future
      setState(() {}); // rebuild FutureBuilder
    } catch (e) {
      AppTopSnackbar.showTopSnackBar(context, "Failed to refresh posts");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: RefreshIndicator(
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        onRefresh: _refreshPosts,
        child: FutureBuilder<List<PostWithUsersModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            // Error
            if (snapshot.hasError) {
              EasyLoading.dismiss();
              AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
              return Center(
                child: Text(
                  "Error loading posts",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              );
            }

            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              LoadingPopup.show('Loading...');
              return const SizedBox.shrink();
            }

            EasyLoading.dismiss();

            final posts = snapshot.data ?? [];

            if (posts.isEmpty) {
              return const EmptyAnimation(title: "No posts yet!");
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  userName: post.user.name,
                  userImage: post.user.profileImage,
                  postUrlList: post.post.images,
                  des: post.post.description ?? "",
                  comments: post.post.likes,
                  likes: post.post.comments,
                  time: post.post.dateTime,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
