import 'package:flutter/material.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/presentation/components/comment.card.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final comments = List.generate(
      30,
      (index) => index % 2 == 0,
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  isNotCurrentUser: comments[index],
                  commentID: "",
                   
                  userID: "",
                  body: "",
                  dateTime: DateTime.now(),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppInput(
                  hintText: "Type your message",
                  prefixIcon: Icons.type_specimen,
                  suffixIcon: Icons.send,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
