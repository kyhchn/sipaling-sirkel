import 'package:firebase_auth/firebase_auth.dart';
import 'package:sipaling_sirkel/variables.dart';

class SendMessageService {
  static Future<bool> sendMessageService(
      User user, String message, String circleCode) async {
    var ref = database.child('circles/$circleCode/messages');
    bool isSucces = false;
    await ref.push().set({
      'uid': user.uid,
      'message': message,
    }).then((value) => isSucces = true);
    return isSucces;
  }
}
