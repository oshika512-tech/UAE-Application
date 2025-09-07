import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:meditation_center/main.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

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
      List<String> cloudinaryUrlList = await uploadImages(imageList, userId,docRef.id);
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

  // (cloudinary) upload function
  Future<List<String>> uploadImages(
    List<XFile> imageList,
    String userID,
    String postsID,

  ) async {
    List<String> uploadedUrls = [];

    try {
      for (int i = 0; i < imageList.length; i++) {
        final file = File(imageList[i].path);

        // Upload to Cloudinary
        var response = await cloudinary.uploader().upload(
              file,
              params: UploadParams(
                publicId:
                    "${userID}_${DateTime.now().millisecondsSinceEpoch}_$i",
                uniqueFilename: false,
                overwrite: true,
                folder: "posts/$postsID",
              ),
            );

        final secureUrl = response?.data?.secureUrl;

        if (secureUrl != null) {
          debugPrint("Uploaded: $secureUrl");
          uploadedUrls.add(secureUrl); // Add uploaded image URL to list
        } else {
          debugPrint("Upload failed for image $i");
        }
      }
    } catch (e) {
      debugPrint("Upload failed: $e");
      return [];
    }

    return uploadedUrls; // Return all uploaded image URLs
  }
}
