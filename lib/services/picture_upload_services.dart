import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_uploading/flutter_image_uploading.dart';
import 'package:http/http.dart' as http;
import 'package:recovery_app/resources/snack_bar.dart';

class PictureUploadService {
  static final cloudinary =
      CloudinaryPublic('djrmgocda', 'ktwsuong', cache: false);
  static void getImageFile(
    BuildContext context,
    void Function(String imageUrl) onSuccess,
  ) async {
    ImageHelper().showPhotoBottomDialog(
      context,
      Platform.isIOS,
      (file) async {
        try {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(file.path,
                resourceType: CloudinaryResourceType.Image),
          );

          print(response.secureUrl);
          onSuccess(response.secureUrl);
        } on CloudinaryException catch (e) {
          print(e.message);
          print(e.request);
          if (context.mounted) {
            showSnackbar(
              e.message ?? "Image upload failed",
              context,
              Icons.warning,
            );
          }
        }
      },
      fileFormat: FileFormat.image, //by default is image
    );
  }
}
