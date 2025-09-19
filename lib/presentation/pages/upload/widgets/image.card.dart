import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class ImageCard {
  static Widget imageCard(
    String imageUrl,
    VoidCallback deleteImage,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,  
          ),
        ),
        Container(
          color: AppColors.textColor.withOpacity(0.5),
          child: Center(
            child: IconButton(
              onPressed: deleteImage,
              icon: Icon(
                Icons.delete,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
