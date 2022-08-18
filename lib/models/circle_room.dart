import 'package:firebase_auth/firebase_auth.dart';
import 'package:sipaling_sirkel/models/message.dart';

class CircleRoom {
  String circleName;
  String? adminUid;
  String? imageUrl;
  List<Message>? messages;
  List<User>? user;
  String circleCode;
  CircleRoom(
      {required this.circleName,
      required this.circleCode,
      this.adminUid,
      this.imageUrl,
      this.messages,
      this.user,});
  Map<String,dynamic> toMap(){
    return {
      'circleName' : circleName,
      'circleCode' : circleCode,
      'adminUid' : adminUid,
      'imageUrl' : imageUrl,
      'messages' : messages,
    };
  }
  factory CircleRoom.RTDB(Map<String, dynamic> data) {
    return CircleRoom(
        circleName: data['circleName'],
        circleCode: data['circleCode'],
        adminUid: data['adminUid'],
        imageUrl: data['imageUrl'],
        messages: data['messages'],
        user: data['user']);
  }
}
