class CommentModel {
  final String id;
  final String postID;
  final String userID;
  final String body;
  final DateTime dateTime;

  CommentModel({
    required this.id,
    required this.postID,
    required this.userID,
    required this.body,
    required this.dateTime,
  });

  // From JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postID: json['postID'] as String,
      userID: json['userID'] as String,
      body: json['body'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postID': postID,
      'userID': userID,
      'body': body,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
