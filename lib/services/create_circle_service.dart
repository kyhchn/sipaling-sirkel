import 'package:firebase_auth/firebase_auth.dart';
import 'package:sipaling_sirkel/models/circle_room.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/variables.dart';

class CreateCircleService {
  static Future<bool> postCircle(
      String circleName, User user, String circleCode) async {
    final child = await database.child('circles/$circleCode');
    final snapshot = await child.get();
    if (snapshot.exists) {
      print('circle already exist');
      return false;
    } else {
      await child
          .set({
            'circleName': circleName,
            'adminUid': user.uid,
            'circleCode': circleCode,
            'users': [user.uid],
          })
          .catchError((errorr) => print(errorr.toString()))
          .then((value) => print('succes creating circles'));
      await SendUserDataService.updateCircleList(
          user,
          CircleRoom(
              adminUid: user.uid,
              circleCode: circleCode,
              circleName: circleName),
          database);
      return true;
    }
  }
}
