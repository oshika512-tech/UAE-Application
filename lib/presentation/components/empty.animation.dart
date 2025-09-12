import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyAnimation extends StatelessWidget {
  final String title;
  const EmptyAnimation({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Lottie.asset(
          'assets/lottie/empty.json',
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ],
    );
  }
}
