import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/data/models/user.model.dart';

class PostWithUserDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Stream<List<PostWithUsersModel>> getAllPosts() {
  return _firestore.collection('posts').snapshots().asyncMap((postSnapshot) async {
    // 1. Map posts
    final posts = postSnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data);
    }).toList();

    if (posts.isEmpty) return [];

    // 2. Collect unique userIds
    final userIds = posts.map((p) => p.userId).toSet().toList();

    // 3. Batch fetch users
    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', whereIn: userIds)
        .get();

    final users = {
      for (var doc in userSnapshot.docs)
        doc['uid']: UserModel.fromJson({...doc.data(), 'id': doc.id})
    };

    // 4. Map posts to PostWithUsers
    final postWithUsers = posts.map((post) {
      final user = users[post.userId];
      if (user != null) {
        return PostWithUsersModel(post: post, user: user);
      } else {
        return PostWithUsersModel(
          post: post,
          user: UserModel(
            id: null,
            name: 'Unknown',
            email: '',
            uid: '',
            profileImage: '',
            isAdmin: false,
          ),
        );
      }
    }).toList();

    // 5. Sort by dateTime
    postWithUsers.sort((a, b) => b.post.dateTime.compareTo(a.post.dateTime));

    return postWithUsers;
  });
}


// get post details by id
Stream<PostWithUsersModel?> getPostDetailsById(String postId) {
  return _firestore.collection('posts').doc(postId).snapshots().asyncMap((docSnapshot) async {
    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data()!;
    final post = PostModel.fromJson(data);

    // Fetch user
    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: post.userId)
        .limit(1)
        .get();

    UserModel user;
    if (userSnapshot.docs.isNotEmpty) {
      final uDoc = userSnapshot.docs.first;
      user = UserModel.fromJson({...uDoc.data(), 'id': uDoc.id});
    } else {
      user = UserModel(
        id: null,
        name: 'Unknown',
        email: '',
        uid: '',
        profileImage: '',
        isAdmin: false,
      );
    }

    return PostWithUsersModel(post: post, user: user);
  });
}


// Manual refresh trigger
  Future<void> refreshPost(String postId) async {
     getAllPosts();
    notifyListeners();
  }


}
