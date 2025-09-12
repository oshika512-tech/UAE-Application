import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/data/models/user.model.dart';

class PostWithUsersProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostWithUsersModel>> getPostsWithUsers() async {
    // 1. Get all posts
    final postSnapshot = await _firestore.collection('posts').get();
    final posts = postSnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson({
        ...data,
        'dateTime': (data['dateTime'] as dynamic) is DateTime
            ? data['dateTime'] as DateTime
            : (data['dateTime'] as Timestamp).toDate(),
      });
    }).toList();

    // 2. Get unique userIds from posts
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

    // 4. Map posts to PostWithUser
    final postWithUsers = posts.map((post) {
      final user = users[post.userId];
      if (user != null) {
        return PostWithUsersModel(post: post, user: user);
      } else {
        // fallback user if not found
        return PostWithUsersModel(
            post: post,
            user: UserModel(
                id: null,
                name: 'Unknown',
                email: '',
                uid: '',
                profileImage: '',
                isAdmin: false));
      }
    }).toList();

// 🔹 Sort by dateTime descending (newest first)
    postWithUsers.sort((a, b) => b.post.dateTime.compareTo(a.post.dateTime));

    return postWithUsers;
  }
}
