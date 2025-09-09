import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/introduction.text.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

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

  continueUpload(
    String text,
    String userName,
    List<XFile> images,
  ) {
    PopupWindow.conformImageUploadPopup(
      text,
      context,
      () async {
        context.pop();
        final userProvider = Provider.of<PostProvider>(context, listen: false);
        // LoadingPopup.show('Uploading...');
        //  process to upload images

        final postStatus = await userProvider.createNewPost(
          descriptionController.text,
          userName,
          images,
        );

        if (postStatus) {
          // EasyLoading.dismiss();
          // EasyLoading.showSuccess('Successfully !',
          //     duration: Duration(seconds: 2));

          setState(() {
            imageList.clear();
            descriptionController.text = "";
          });
        } else {
          EasyLoading.dismiss();
          AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<UserProvider>(
        builder: (
          BuildContext context,
          UserProvider userProvider,
          Widget? child,
        ) =>
            FutureBuilder(
          future:
              userProvider.getUserById(FirebaseAuth.instance.currentUser!.uid),
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
              final user = snapshot.data as UserModel;
              EasyLoading.dismiss();

              return Column(
                children: [
                  const SizedBox(height: 20),
                  _textFormField(
                    context,
                    descriptionController,
                  ),
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
                        onTap: () {
                          if (imageList.isNotEmpty) {
                            if (descriptionController.text.isEmpty) {
                              continueUpload(
                                  "Conform to upload images without description ?",
                                  user.name,
                                  imageList);
                            } else {
                              continueUpload(
                                "Conform to upload images ?",
                                user.name,
                                imageList,
                              );
                            }
                          } else {
                            AppTopSnackbar.showTopSnackBar(
                                context, "Please select images to upload");
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                 imageList.isNotEmpty? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Selected:  ${imageList.length}",
                            style: Theme.of(context).textTheme.bodySmall),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              imageList.clear();
                            });
                          },
                          child: Text(
                            "Clear",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                  ): const SizedBox.shrink(),
                  const SizedBox(height: 10),
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
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
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
                          ),
                        ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
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

  Widget _textFormField(
    BuildContext context,
    TextEditingController controller,
  ) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Description',
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.gray,
            ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
