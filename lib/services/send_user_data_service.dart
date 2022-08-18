import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sipaling_sirkel/models/circle_room.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';

class SendUserDataService {
  static Future postUserData(
      UserDatabase target, DatabaseReference database) async {
    final child = await database.child('users/${target.uid}');
    final snapshot = await child.get();
    if (snapshot.exists) {
      print('data found, tying to update the values');
      List<Map<String, dynamic>> circleList = [];
      target.listCircle!.forEach((element) {
        circleList.add({
          'circleName': element.circleName,
          'circleCode': element.circleCode,
        });
      });
      await child.update({
        'displayName': target.displayName,
        'imageUrl': target.imageUrl,
        'uid': target.uid,
        'email': target.email,
        'circleList': circleList
      }).catchError((errorr) => errorr.toString());
    } else {
      print('data doesn\'t found, trying to write user data to database');
      List x = [];
      await child.set({
        'uid': target.uid,
        'email': target.email,
        'displayName': target.displayName,
        'imageUrl': target.imageUrl
      }).catchError((errorr) => print('errorr happens ${errorr.toString()}'));
    }
  }

  static Future updateCircleList(
      User target, CircleRoom addCircle, DatabaseReference database) async {
    UserDatabase data = await GetUserData.getUserData(target);
    if (data.listCircle == null) {
      print('null');
    } else {
      print('not null');
      data.listCircle!.forEach((element) {
        print(element.circleCode + ' ' + element.circleName + ' before add');
      });
    }
    if (data.listCircle != null) {
      data.listCircle!.add(addCircle);
    } else {
      data.listCircle = [addCircle];
    }
    data.listCircle!.forEach((element) {
      print(element.circleCode + ' ' + element.circleName + ' after add');
    });
    postUserData(data, database);
  }
}
