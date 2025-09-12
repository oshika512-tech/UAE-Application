import 'package:flutter/material.dart';
import 'package:meditation_center/core/constans/app.constans.dart';
import 'package:meditation_center/presentation/pages/comments/comment.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class NoticeCard extends StatefulWidget {
  final String userName;
  final String userImage;
  final List<String> postUrlList;
  final String des;
  final int likes;
  final int comments;
  const NoticeCard({
    super.key,
    required this.userName,
    required this.userImage,
    required this.postUrlList,
    required this.likes,
    required this.comments,
    required this.des,
  });

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  bool isMore = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // user info
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      widget.userImage != ""
                          ? widget.userImage
                          : AppData.baseUserUrl,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "1 min ago",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.gray, fontSize: 12),
                      ),
                    ],
                  ),
                ],
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
                    _imageCard(
                      context,
                      false,
                      widget.postUrlList.length,
                      widget.postUrlList[0],
                      widget.postUrlList.length != 1
                          ? widget.postUrlList[1]
                          : "null",
                    ),
                    const SizedBox(height: 10),
                    widget.postUrlList.length > 2
                        ? _imageCard(
                            context,
                            true,
                            widget.postUrlList.length,
                            widget.postUrlList[2],
                            widget.postUrlList.length != 3
                                ? widget.postUrlList[3]
                                : "null",
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
                    Text("${widget.likes} like",
                        style: Theme.of(context).textTheme.bodySmall),
                    Text("${widget.comments} comments",
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionBtn(
                      context,
                      Icons.thumb_up,
                      "Like",
                      isLiked,
                      () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                    _actionBtn(
                      context,
                      Icons.comment,
                      "Comment",
                      false,
                      () {
                        CommentPage.bottomSheet(context);
                      },
                    ),
                    _actionBtn(
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

  Widget _actionBtn(
    BuildContext context,
    IconData icon,
    String text,
    bool isColors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isColors ? AppColors.primaryColor : null,
          border: Border.all(
            color: isColors ? AppColors.primaryColor : AppColors.gray,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isColors ? AppColors.whiteColor : AppColors.gray,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        isColors ? AppColors.whiteColor : AppColors.textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageCard(
    BuildContext context,
    bool lastChild,
    int length,
    String imageUrl1,
    String imageUrl2,
  ) {
    return Row(
      mainAxisAlignment: length == 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        Image.network(
          imageUrl1,
          width: length == 1
              ? MediaQuery.of(context).size.width * 0.85
              : MediaQuery.of(context).size.width * 0.43,
          height: length == 1 ? null : 150,
          fit: BoxFit.cover,
        ),
        imageUrl2 != "null"
            ? Stack(
                children: [
                  Image.network(
                    imageUrl2,
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  lastChild
                      ? Container(
                          color: const Color.fromARGB(143, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: 200,
                          child: Center(
                            child: Text(
                              "${length - 4} +",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
