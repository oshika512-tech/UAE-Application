import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PostCardComponents {
  

static 
  Widget imageCard(
    BuildContext context,
    bool lastChild,
    int length,
    String imageUrl1,
    String imageUrl2,
  ) {
    return Row(
      mainAxisAlignment: length == 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        Image.network(
          imageUrl1,
          width: length == 1
              ? MediaQuery.of(context).size.width * 0.85
              : MediaQuery.of(context).size.width * 0.43,
          height: length == 1 ? null : 150,
          fit: BoxFit.cover,
        ),
        imageUrl2 != "null"
            ? Stack(
                children: [
                  Image.network(
                    imageUrl2,
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  lastChild && length > 4
                      ? Container(
                          color: const Color.fromARGB(143, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: 200,
                          child: Center(
                            child: Text(
                              "${length - 4} +",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }
  
  static Widget actionBtn(
    BuildContext context,
    IconData icon,
    String text,
    bool isColors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isColors ? AppColors.primaryColor : null,
          border: Border.all(
            color: isColors ? AppColors.primaryColor : AppColors.gray,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isColors ? AppColors.whiteColor : AppColors.gray,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        isColors ? AppColors.whiteColor : AppColors.textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }


}