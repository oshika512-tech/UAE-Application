class PostModel {
  final String? description;
  final String userId;
  final String userName;
  final DateTime dateTime;
  final List<String> images;

  PostModel({
    required this.description,
    required this.userId,
    required this.userName,
    required this.dateTime,
    required this.images,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      description: json['description'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      dateTime: json['dateTime'] as DateTime,
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'userId': userId,
      'userName': userName,
      'dateTime': dateTime,
      'images': images,
    };
  }
}
