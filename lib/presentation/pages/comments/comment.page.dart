import 'package:flutter/material.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/presentation/components/comment.card.dart';

class CommentPage {
  static bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    // Comment list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 5,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return CommentCard(isNotCurrentUser: true);
                        },
                      ),
                    ),
                    // Input field at bottom
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: AppInput(
                          hintText: "Type your message",
                          prefixIcon: Icons.type_specimen,
                          suffixIcon: Icons.send,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
