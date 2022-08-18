import 'package:sipaling_sirkel/models/circle_room.dart';

class UserDatabase {
  String uid, email;
  String? imageUrl, displayName;
  List<CircleRoom>? listCircle;
  UserDatabase(
      {required this.uid,
      required this.email,
      this.displayName,
      this.imageUrl,
      this.listCircle});
  factory UserDatabase.fromRTDB(Map<String, dynamic> data) {
    return UserDatabase(
        uid: data['uid'],
        email: data['email'],
        displayName: data['displayName'],
        imageUrl: data['imageUrl'],
        listCircle: fetchListCircle(data['circleList'] ?? null));
  }
}

List<CircleRoom>? fetchListCircle(List<dynamic>? data) {
  if (data != null) {
    List<CircleRoom> listCircle = [];
    data.forEach((element) {
      final data = Map.from(element);
      listCircle.add(CircleRoom(
          circleName: data['circleName'], circleCode: data['circleCode']));
    });
    return listCircle;
  }
  return null;
}
