import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:saver_gallery/saver_gallery.dart';

class DownloadServices {
  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }

  saveGif(String url, String imageName, BuildContext context) async {
    checkAndRequestPermissions(
      skipIfExists: false,
    );
    var response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await SaverGallery.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      fileName: imageName,
      androidRelativePath: "Pictures/MediationCenter/downloads",
      skipIfExists: false,
    );

    if (result.isSuccess) {
      EasyLoading.showSuccess("Image saved",duration: const Duration(seconds: 2),maskType: EasyLoadingMaskType.clear,);
    } else {
      AppTopSnackbar.showTopSnackBar(context, "Failed to save image");
    }
  }
}
