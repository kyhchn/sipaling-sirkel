import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:sipaling_sirkel/main_colors.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/create_circle_service.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/join_circle_service.dart';
import 'package:sipaling_sirkel/services/send_message_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/views/chat_room.dart';

class HomePage extends StatelessWidget {
  final User user;
  HomePage({Key? key, required this.user});
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCUM'),
      ),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        backgroundColor: MainColors.lightGrey,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.1,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(user.photoURL!),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              user.displayName!,
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1.5,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.settings),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Settings')
                              ],
                            ),
                          ),
                      separatorBuilder: (context, index) => Container(
                            height: 1.5,
                            color: Colors.grey,
                          ),
                      itemCount: 5)),
              IconButton(
                  onPressed: () async {
                    await FlutterFireUIAuth.signOut(
                        context: context, auth: FirebaseAuth.instance);
                  },
                  icon: Icon(Icons.power_settings_new))
            ],
          ),
        ),
      ),
    );
  }
}
