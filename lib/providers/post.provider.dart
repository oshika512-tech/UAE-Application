import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/notifications/create.notification.dart';
import 'package:meditation_center/data/cloudinary/cloudinary_api.dart';
import 'package:meditation_center/data/models/post.model.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  double uploadProgress = 0.0;
  double totalUpload = 0.0;
  bool isDone = false;

  // create new post

  Future<bool> createNewPost(
    String des,
    String name,
    List<XFile> imageList,
  ) async {
    // reset upload progress
    isDone = false;
    uploadProgress = 0.0;
    final docRef = _firestore.collection('posts').doc();

    final post = PostModel(
      description: des,
      userId: userId,
      userName: name,
      dateTime: DateTime.now(),
      images: [],
    );

    try {
      // create dummy post
      await docRef.set({...post.toJson()});

      uploadProgress = 0.0;
      notifyListeners();

      // upload images to cloudinary
      List<String> cloudinaryUrlList =
          await uploadImages(imageList, userId, docRef.id);
      if (cloudinaryUrlList.isEmpty) {
        return false;
      }
      // update post with image urls
      await docRef.update({'images': cloudinaryUrlList});

      // show notification
      CreateNotification.showNotification(
        "Successfully uploaded ",
        des != ""
            ? des
            : "Your post is uploaded successfully!, Thank you for sharing your moments with us.",
        docRef.id.hashCode,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating post: $e');
      notifyListeners();
      return false;
    }
  }

  Future<List<String>> uploadImages(
    List<XFile> imageList,
    String userID,
    String postsID,
  ) async {
    List<String> uploadedUrls = [];

    try {
      uploadProgress = 0.0;
      isDone = false; // reset when starting upload
      notifyListeners();

      int totalFiles = imageList.length;
      int completedFiles = 0;

      // CloudinaryUploadResource list create
      final resources = imageList.asMap().entries.map(
        (entry) {
          int index = entry.key;
          XFile file = entry.value;

          return CloudinaryUploadResource(
            filePath: file.path,
            resourceType: CloudinaryResourceType.image,
            folder: "posts/$postsID",
            fileName:
                "${userID}_${DateTime.now().millisecondsSinceEpoch}_$index",
            progressCallback: (count, total) {
              // one file progress
              double fileProgress = count / total;

              // overall progress
              double overallProgress =
                  ((completedFiles + fileProgress) / totalFiles) * 100;

              uploadProgress = overallProgress;
              notifyListeners();
            },
          );
        },
      ).toList();

      // Upload resources
      List<CloudinaryResponse> responses =
          await CloudinarySdk.cloudinary.uploadResources(resources);

      // Handle responses
      for (var response in responses) {
        if (response.isSuccessful) {
          uploadedUrls.add(response.secureUrl!);
        }
        completedFiles++;
        uploadProgress = (completedFiles / totalFiles) * 100;
        notifyListeners();
      }

      if (completedFiles == totalFiles) {
        isDone = true;
        notifyListeners();
      }
    } catch (e) {
      isDone = true;
      notifyListeners();

      debugPrint(" Upload failed: $e");
      return [];
    }

    return uploadedUrls;
  }
}
