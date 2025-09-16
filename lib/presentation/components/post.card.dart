import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/datetime/datetime.calculate.dart';
import 'package:meditation_center/presentation/components/post.card.Components.dart';
import 'package:meditation_center/presentation/components/post.card.user.info.dart';
import 'package:meditation_center/core/shimmer/post.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String postID;
  final bool isHome;
  final bool isCUser;
  const PostCard({
    super.key,
    required this.postID,
    required this.isHome,
    required this.isCUser,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  bool isMore = false;
  bool isLiked = false;
  int numOfLikes = 0;
  int numOfComments = 0;
  final cUser = FirebaseAuth.instance.currentUser!.uid;

  void checkUserLikeStatus(PostProvider postProvider) async {
    bool status = await postProvider.hasUserLikedPost(widget.postID, cUser);
    if (!mounted) return;
    setState(() {
      isLiked = status;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    checkUserLikeStatus(postProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postWithUserDataProvider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: StreamBuilder(
            stream: postWithUserDataProvider.getPostDetailsById(widget.postID),
            builder: (context, snapshot) {
              // First time load only
              if (!snapshot.hasData) {
                return const PostShimmer();
              }

              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error loading post",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text("Try again"),
                    ),
                  ],
                );
              }

              final postData = snapshot.data!;

              // Local UI update
              numOfLikes = postData.post.likes;
              numOfComments = postData.post.comments;

              return Column(
                children: [
                  // user info
                  widget.isHome
                      ? PostCardUserInfo(
                          userId: postData.user.uid,
                          userName: postData.user.name,
                          userImage: postData.user.profileImage,
                          time: postData.post.dateTime,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: widget.isCUser
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                DatetimeCalculate.timeAgo(
                                    postData.post.dateTime),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              widget.isCUser
                                  ? Icon(
                                      Icons.more_vert_rounded,
                                      size: 20,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMore = !isMore;
                              });
                            },
                            child: Text(
                              postData.post.description ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: !isMore ? TextOverflow.ellipsis : null,
                              maxLines: isMore ? null : 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  postData.post.description != ""
                      ? const SizedBox(height: 10)
                      : const SizedBox.shrink(),

                  // content images
                  Container(
                    color: AppColors.gray.withOpacity(0.05),
                    width: double.infinity,
                    child: Column(
                      children: [
                        if (postData.post.images.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              context.push(
                                '/viewer',
                                extra: postData.post.images,
                              );
                            },
                            child: PostCardComponents.imageCard(
                              context,
                              false,
                              postData.post.images.length,
                              postData.post.images[0],
                              postData.post.images.length > 1
                                  ? postData.post.images[1]
                                  : "null",
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (postData.post.images.length > 2)
                          GestureDetector(
                            onTap: () {
                              context.push(
                                '/viewer',
                                extra: postData.post.images,
                              );
                            },
                            child: PostCardComponents.imageCard(
                              context,
                              true,
                              postData.post.images.length,
                              postData.post.images[2],
                              postData.post.images.length != 3
                                  ? postData.post.images[3]
                                  : "null",
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$numOfLikes like",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "$numOfComments comments",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PostCardComponents.actionBtn(
                          context,
                          Icons.thumb_up,
                          "Like",
                          isLiked,
                          () {
                            setState(() {
                              isLiked = !isLiked;
                              if (isLiked) {
                                numOfLikes++;
                                postProvider.likePost(widget.postID, cUser);
                              } else {
                                numOfLikes--;
                                postProvider.dislikePost(widget.postID, cUser);
                              }
                            });
                          },
                        ),
                        PostCardComponents.actionBtn(
                          context,
                          Icons.comment,
                          "Comment",
                          false,
                          () {
                            (context).push('/comment', extra: widget.postID);
                          },
                        ),
                        PostCardComponents.actionBtn(
                          context,
                          Icons.share_outlined,
                          "Share",
                          false,
                          () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
