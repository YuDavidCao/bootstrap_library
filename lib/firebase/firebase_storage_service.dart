import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<void> uploadPictureToImage(
      File filepath, String bookId, BuildContext context) async {
    try {
      final storage = FirebaseStorage.instance;
      final folderRef = storage.ref().child('image');
      await folderRef.child("/$bookId").putFile(filepath);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      }
    }
  }

  static Future<String> getImageBookImageUrl(String bookId) {
    return FirebaseStorage.instance
        .ref()
        .child("image/$bookId")
        .getDownloadURL();
  }

  static Future<Widget> renderBookImage(String id, bool mini) async {
    if (mini) {
      return SizedBox(
        height: 100,
        child: Image.network(
            await FirebaseStorageService.getImageBookImageUrl(id)),
      );
    } else {
      return Image.network(
          await FirebaseStorageService.getImageBookImageUrl(id));
    }
  }
}
