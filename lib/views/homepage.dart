import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/create_circle_service.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/join_circle_service.dart';
import 'package:sipaling_sirkel/services/send_message_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';

class HomePage extends StatelessWidget {
  final User user;
  HomePage({Key? key, required this.user});
  final Rx<TextEditingController> _messageController =
      TextEditingController().obs;
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome back ${user.displayName}'),
        ),
        body: Obx(() {
          return SafeArea(
            child: Column(
              children: [
                TextField(
                  controller: _messageController.value,
                  decoration: InputDecoration(
                      suffix: IconButton(
                          onPressed: () async =>
                              SendMessageService.sendMessageService(user,
                                  _messageController.value.text, 'hai sayang'),
                          icon: Icon(Icons.send))),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await JoinCircleService.getCircle(user, 'babi123');
                    },
                    child: Text('join circle babi')),
                ElevatedButton(
                    onPressed: () async {
                      await JoinCircleService.getCircle(user, 'buba123');
                    },
                    child: Text('join circle buba')),
                ElevatedButton(
                    onPressed: () async {
                      await CreateCircleService.postCircle(
                          'babi', user, 'babi123');
                    },
                    child: Text('create circle babi')),
                ElevatedButton(
                    onPressed: () async {
                      await CreateCircleService.postCircle(
                          'buba', user, 'buba123');
                    },
                    child: Text('create circle buba')),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                SignOutButton(),
                Text('here\'s your circle'),
                Expanded(
                  child: StreamBuilder(
                    stream:
                        database.child('users/${user.uid}/circleList').onValue,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('.. is empty like your brain');
                      } else {
                        if ((snapshot.data! as DatabaseEvent)
                            .snapshot
                            .value
                            .isNull) {
                          return Text('.. is empty like your brain');
                        } else {
                          final listTile = <ListTile>[];
                          final listCircle = ((snapshot.data! as DatabaseEvent)
                              .snapshot
                              .value) as List;
                          listCircle.forEach((val) {
                            final data = Map<String, dynamic>.from(val);
                            final circle = ListTile(
                              title: Text(data['circleName']),
                              subtitle: Text(data['circleCode']),
                            );
                            listTile.add(circle);
                          });
                          return ListView(
                            children: listTile,
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }));
  }
}
