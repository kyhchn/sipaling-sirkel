import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sipaling_sirkel/models/circle_room.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/variables.dart';

class JoinCircleService {
  static Future<String> joinCircle(User user, String circleCode) async {
    final child = database.child('circles/$circleCode');
    final snapshot = await child.get();
    if (snapshot.exists) {
      final circleList =
          await database.child('users/${user.uid}/circleList').get();
      String circleName =
          Map.from(jsonDecode(jsonEncode(snapshot.value)))['circleName'];
      if (circleList.exists) {
        List<dynamic> data = jsonDecode(jsonEncode(circleList.value));
        bool check() {
          bool ret = true;
          for (var element in data) {
            if (element['circleCode'] == circleCode) {
              ret = false;
              break;
            }
          }
          return ret;
        }
        if (check()) {
          List<String> listUsers =
              List.from(snapshot.child('users').value as List);
          listUsers.add(user.uid);
          await SendUserDataService.updateCircleList(
              user,
              CircleRoom(circleName: circleName, circleCode: circleCode),
              database);
          await child.update({'users': listUsers});
          return 'Success to join new circle1';
        } else {
          return 'Already join this circle1';
        }
      } else {
        List<String> listUsers =
            List.from(snapshot.child('users').value as List);
        listUsers.add(user.uid);
        await SendUserDataService.updateCircleList(
            user,
            CircleRoom(
              circleName: circleName,
              circleCode: circleCode,
            ),
            database);
        await child.update({'users': listUsers});
      }
      return 'Success to join new circle2';
    } else {
      return 'circle doesn\'t found!!';
    }
  }
}
