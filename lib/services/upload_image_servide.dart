import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sipaling_sirkel/controllers/send_user_data.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/variables.dart';

class UploadImageService {
  File targetFile;
  UploadImageService({required this.targetFile});
  Future<void> uploadProfileUser(User user, BuildContext context) async {
    String fileName = p.basename(targetFile.path);
    final firebaseReference =
        FirebaseStorage.instance.ref().child('users/${user.uid}/$fileName');
    print('instance already initialized');
    try {
      print('start uploading to firebase');
      var uploadTask = await firebaseReference.putFile(targetFile);
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      UserDatabase updater = await GetUserData.getUserData(user);
      updater.imageUrl = downloadUrl;
      print('start update profile');
      await SendUserDataService.postUserData(updater, database);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Success to update profile')));
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }
}
