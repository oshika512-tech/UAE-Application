import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? description;
  final String userId;
  final String userName;
  final DateTime dateTime;
  final List<String> images;
  final int likes;
  final int comments;
  final List<String> comment_ids;

  PostModel({
    required this.description,
    required this.userId,
    required this.userName,
    required this.dateTime,
    required this.images,
    required this.likes,
    required this.comments,
    required this.comment_ids,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      description: json['description'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      dateTime: (json['dateTime'] as dynamic) is DateTime
          ? json['dateTime'] as DateTime
          : (json['dateTime'] as Timestamp).toDate(), 
      images: List<String>.from(json['images'] ?? []),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      comment_ids: List<String>.from(json['comments_id'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'userId': userId,
      'userName': userName,
      'dateTime': dateTime,
      'images': images,
      'likes': likes,
      'comments': comments,
      'comments_id': comment_ids,
    };
  }
}
