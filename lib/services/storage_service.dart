import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage = FirebaseStorage.instance;

  Future<void> uploadImage(String filePath, String fileName, User user) async {
    File file = await File(filePath).create();
    try {
      await storage.ref('${user.uid}/profile/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
