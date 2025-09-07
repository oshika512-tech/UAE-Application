import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/introduction.text.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ImagePicker picker = ImagePicker();
  List<XFile> imageList = [];
  final TextEditingController descriptionController = TextEditingController();

  // pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        imageList.addAll(pickedFiles);
      });
    } else {
      print('No images selected.');
    }
  }

  void _processUpload() {
    if (descriptionController.text.isEmpty) {
      continueUpload("Conform to upload images without description ?");
    } else {
      continueUpload("Conform to upload images ?");
    }
  }

  continueUpload(String text) {
    PopupWindow.conformImageUploadPopup(
      text,
      context,
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _textFormField(context),
          const SizedBox(height: 20),
          // pick image btn
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButtons(
                text: "Select",
                isPrimary: true,
                icon: Icons.image,
                width: MediaQuery.of(context).size.width * 0.42,
                height: 50,
                onTap: _pickImagesFromGallery,
              ),
              AppButtons(
                text: "Upload",
                isPrimary: true,
                icon: Icons.upload,
                width: MediaQuery.of(context).size.width * 0.42,
                height: 50,
                onTap: _processUpload,
              ),
            ],
          ),
          const SizedBox(height: 20),
          imageList.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: imageList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        //  images preview
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _imageCard(
                            imageList[index].path,
                            () {
                              setState(() {
                                imageList.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    IntroductionText.text(
                      theme,
                      "Click on the select images button to select an image",
                      true,
                    ),
                    IntroductionText.text(
                      theme,
                      "You can select multiple images at once",
                      true,
                    ),
                    IntroductionText.text(
                      theme,
                      "After selecting images, you can delete any image by clicking on the delete icon",
                      true,
                    ),
                    IntroductionText.text(
                      theme,
                      "Add description about your post in the description field",
                      true,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _imageCard(
    String imageUrl,
    VoidCallback deleteImage,
  ) {
    return Stack(
      children: [
        Center(
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: AppColors.textColor.withOpacity(0.5),
          child: Center(
            child: IconButton(
              onPressed: deleteImage,
              icon: Icon(
                Icons.delete,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFormField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: 'Description',
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.gray,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
