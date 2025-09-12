import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id ;
  final String title;
  final String body;
  final String userID;
  final DateTime dateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userID,
    required this.dateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userID: json['userID'] ?? '',
      dateTime: (json['dateTime'] is String)
          ? DateTime.parse(json['dateTime'])
          : (json['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userID': userID,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
