import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/presentation/components/post.card.Components.dart';
import 'package:meditation_center/presentation/components/post.card.user.info.dart';
import 'package:meditation_center/presentation/pages/comments/comment.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String userName;
  final String userImage;
  final List<String> postUrlList;
  final String des;
  final int likes;
  final int comments;
  final DateTime time;
  final String postID;
  const PostCard({
    super.key,
    required this.userName,
    required this.userImage,
    required this.postUrlList,
    required this.likes,
    required this.comments,
    required this.des,
    required this.time,
    required this.postID,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isMore = false;
  bool isLiked = false;
  int numOfLikes = 0;
  int numOfComments = 0;
  final cUser = FirebaseAuth.instance.currentUser!.uid;

  void assignNum() {
    setState(() {
      numOfLikes = widget.likes;
      numOfComments = widget.comments;
    });
  }

  void checkUserLikeStatus() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    bool status = await postProvider.hasUserLikedPost(widget.postID, cUser);
    if (!mounted) return; 
    setState(() {
      isLiked = status;
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLikeStatus();
    assignNum();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // user info
              PostCardUserInfo(
                userName: widget.userName,
                userImage: widget.userImage,
                time: widget.time,
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
                          widget.des,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: !isMore ? TextOverflow.ellipsis : null,
                          maxLines: isMore ? null : 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              widget.des != "" ? SizedBox(height: 10) : SizedBox.shrink(),

              // content
              Container(
                color: AppColors.gray.withOpacity(0.05),
                width: double.infinity,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(
                          '/viewer',
                          extra: widget.postUrlList,
                        );
                      },
                      child: PostCardComponents.imageCard(
                        context,
                        false,
                        widget.postUrlList.length,
                        widget.postUrlList[0],
                        widget.postUrlList.length != 1
                            ? widget.postUrlList[1]
                            : "null",
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.postUrlList.length > 2
                        ? GestureDetector(
                            onTap: () {
                              context.push(
                                '/viewer',
                                extra: widget.postUrlList,
                              );
                            },
                            child: PostCardComponents.imageCard(
                              context,
                              true,
                              widget.postUrlList.length,
                              widget.postUrlList[2],
                              widget.postUrlList.length != 3
                                  ? widget.postUrlList[3]
                                  : "null",
                            ),
                          )
                        : SizedBox.shrink(),
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
                child: Consumer(
                  builder: (BuildContext context, PostProvider postProvider,
                          child) =>
                      Row(
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
                          });

                          if (isLiked) {
                            numOfLikes++;
                            postProvider.likePost(widget.postID, cUser);
                          } else {
                            numOfLikes--;
                            postProvider.dislikePost(widget.postID, cUser);
                          }
                        },
                      ),
                      PostCardComponents.actionBtn(
                        context,
                        Icons.comment,
                        "Comment",
                        false,
                        () {
                          CommentPage.bottomSheet(context);
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
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Container(
          height: 10,
          width: double.infinity,
          color: AppColors.gray.withOpacity(0.1),
        ),
      ],
    );
  }
}
