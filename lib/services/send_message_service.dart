import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class SendMessageService {
  Future postMessage(User target, String message) async {
    await http
        .post(
            Uri.parse(
              'https://sambat-yuk-default-rtdb.asia-southeast1.firebasedatabase.app/message.json',
            ),
            body: jsonEncode({
              'id': target.uid.toString(),
              'message': message,
              'datetime': DateTime.now().toString()
            }))
        .then((value) => print(value.statusCode));
  }
}
