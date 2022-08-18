import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/variables.dart';

class GetUserData {
  static Future<UserDatabase> getUserData(User user) async {
    final snapshot = await database.child('users/${user.uid}').get();
    if (snapshot.exists) {
      Map<String,dynamic> data = jsonDecode(jsonEncode(snapshot.value));
      print('data exist');
      return UserDatabase.fromRTDB(data);
    } else {
      print('data doesnt exist');
      return UserDatabase(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName,
          imageUrl: user.photoURL,
          listCircle: []);
    }
  }
}
