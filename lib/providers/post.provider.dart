import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/data/cloudinary/cloudinary_api.dart';
import 'package:meditation_center/data/models/post.model.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  double uploadProgress = 0;

  // create new post
  Future<bool> createNewPost(
    String des,
    String name,
    List<XFile> imageList,
  ) async {
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
      // upload images to cloudinary
      List<String> cloudinaryUrlList =
          await uploadImages(imageList, userId, docRef.id);
      if (cloudinaryUrlList.isEmpty) {
        return false;
      }
      // update post with image urls
      await docRef.update({'images': cloudinaryUrlList});
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
      // CloudinaryUploadResource list   create
      final resources = await Future.wait(
        imageList.asMap().entries.map((entry) async {
          int index = entry.key;
          XFile file = entry.value;

          return CloudinaryUploadResource(
            filePath: file.path,
            resourceType: CloudinaryResourceType.image,
            folder: "posts/$postsID",
            fileName:
                "${userID}_${DateTime.now().millisecondsSinceEpoch}_$index",
            // upload percentage
            progressCallback: (count, total) {
              int percent = ((count / total) * 100).round();
              uploadProgress = percent.toDouble();
              notifyListeners();
            },
          );
        }),
      );

      // Upload resources
      List<CloudinaryResponse> responses =
          await CloudinarySdk.cloudinary.uploadResources(resources);

      // Handle responses
      for (var response in responses) {
        if (response.isSuccessful) {
          debugPrint(" Uploaded: ${response.secureUrl}");
          uploadedUrls.add(response.secureUrl!);
        } else {
          debugPrint(" Failed: ${response.error}");
        }
      }
    } catch (e) {
      debugPrint(" Upload failed: $e");
      return [];
    }

    return uploadedUrls;
  }
}
