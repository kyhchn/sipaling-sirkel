import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:sipaling_sirkel/controllers/send_message.dart';

class HomePage extends StatelessWidget {
  final User user;
  HomePage({Key? key, required this.user}) : super(key: key);
  final Rx<TextEditingController> _messageController =
      TextEditingController().obs;
  @override
  Widget build(BuildContext context) {
    print(user.displayName);
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome back ${user.email}'),
        ),
        body: Obx(() => SafeArea(
              child: Column(
                children: [
                  TextField(
                    controller: _messageController.value,
                    decoration: InputDecoration(
                        suffix: IconButton(
                            onPressed: () async => SendMessage().sendMessage(
                                user, _messageController.value.text),
                            icon: Icon(Icons.send))),
                  ),
                  SignOutButton()
                ],
              ),
            )));
  }
}
