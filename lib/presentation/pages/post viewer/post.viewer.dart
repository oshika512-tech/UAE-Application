import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PostViewer extends StatefulWidget {
  final List<String> imagesList;
  const PostViewer({
    super.key,
    required this.imagesList,
  });

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  int index = 0;

  void _next() {
    if (index < widget.imagesList.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  void _previous() {
    if (index > 0) {
      setState(() {
        index--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PopupMenuButton<int>(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    if (value == 1) {
                      //TODO : download image
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Download",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  // swipe left → next
                  _next();
                } else if (details.primaryVelocity! > 0) {
                  // swipe right → previous
                  _previous();
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.width * 1.9,
                child: Center(
                  child: Image.network(
                    widget.imagesList[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
