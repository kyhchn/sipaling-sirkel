import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sipaling_sirkel/models/circle_room.dart';
import 'package:sipaling_sirkel/variables.dart';

class MessageService {
  SendMessage(User user, String circleCode, String content) async {
    final child =
        FirebaseDatabase.instance.ref("circles/${circleCode}/messages");
    final data = await child.orderByChild("dateTime").get();
    List<dynamic> messages = [];
    if (data.exists) {
      messages = jsonDecode(jsonEncode(data.value));
      messages.add({
        'message': content,
        'uid': user.uid,
        'datetime': DateTime.now().microsecondsSinceEpoch
      });
    } else {
      messages = [
        {
          'message': content,
          'uid': user.uid,
          'datetime': DateTime.now().microsecondsSinceEpoch
        }
      ];
    }
    await database
        .child('circles/${circleCode}')
        .update({'messages': messages});
  }
}
