class NoticeModel {
  final String? id;
  final String title;
  final String body;
  final String mainImage;
  final DateTime dateTime;

  NoticeModel({
      this.id,
    required this.title,
    required this.body,
    required this.mainImage,
    required this.dateTime,
  });

   factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      mainImage: json['mainImage'] as String,
      dateTime: json['dateTime'] as DateTime,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'mainImage': mainImage,
      'dateTime': dateTime,
    };
  }
}