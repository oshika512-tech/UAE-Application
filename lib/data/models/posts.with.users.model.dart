import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/user.model.dart';

class PostWithUsersModel {
  final PostModel post;
  final UserModel user;

  PostWithUsersModel({
    required this.post,
    required this.user,
  });
}
