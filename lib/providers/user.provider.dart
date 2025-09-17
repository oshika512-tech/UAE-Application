import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/data/cloudinary/cloudinary_api.dart';
import 'package:meditation_center/data/models/user.model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // update user
  Future<bool> updateUser(UserModel user) async {
    final docRef = _firestore.collection('users').doc(
          FirebaseAuth.instance.currentUser!.uid,
        );

    try {
      await docRef.update({...user.toJson()});
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print('Error updating task: $e');
      return false;
    }
  }

  // get user by id
  Future<UserModel> getUserById(String id) async {
    final snapshot = await _firestore.collection('users').doc(id).get();
    return UserModel.fromJson(snapshot.data()!);
  }

 


// cloudinary upload image
  Future<bool> uploadUserProfileImage(
    XFile imagePath,
    String userID,
    BuildContext context,
    UserModel currentUser,
  ) async {
    try {
      final response = await CloudinarySdk.cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imagePath.path,
          resourceType: CloudinaryResourceType.image,
          folder: "users",
          fileName: userID,
          progressCallback: (count, total) {
            debugPrint("Uploading... $count/$total");
          },
        ),
      );

      if (response.isSuccessful) {
        debugPrint(" Uploaded successfully: ${response.secureUrl}");

        // update your user model with new image
        final profileImage = response.secureUrl;
        final updateUserData = await updateUser(
          UserModel(
            name: currentUser.name,
            email: currentUser.email,
            uid: currentUser.uid,
            profileImage: profileImage.toString(),
            isAdmin: false,
          ),
        );

        if (updateUserData) {
          return true;
        } else {
          debugPrint(" Uploaded but update user failed");
          return false;
        }
      } else {
        debugPrint(" Upload failed: ${response.error}");
        return false;
      }
    } catch (e) {
      debugPrint(" Exception: $e");
      return false;
    }
  }

  // update user name
  Future<bool> updateUserName(String newName) async {
    final docRef = _firestore.collection('users').doc(
          FirebaseAuth.instance.currentUser!.uid,
        );

    try {
      await docRef.update({
        'name': newName,
      });
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print('Error updating name: $e');
      return false;
    }
  }
}
