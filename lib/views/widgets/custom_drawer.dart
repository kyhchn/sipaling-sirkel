import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:sipaling_sirkel/main_colors.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'dart:io';

import 'package:sipaling_sirkel/services/image_picker_service.dart';
import 'package:sipaling_sirkel/services/upload_image_servide.dart';
import 'package:sipaling_sirkel/variables.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: MainColors.lightGrey,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StreamBuilder(
                    stream: database.child('users/${user.uid}').onValue,
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final data = jsonDecode(jsonEncode(
                          ((snapshot.data! as DatabaseEvent)
                              .snapshot
                              .value))) as Map<String, dynamic>;
                      final user = UserDatabase.fromRTDB(data);
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * 0.1,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(user.imageUrl!),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      user.displayName!,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 23,
                                      ),
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
                      );
                    }))),
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
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      await FlutterFireUIAuth.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Success to Log Out')));
                    },
                    icon: Icon(Icons.power_settings_new)),
                ElevatedButton(
                    onPressed: () async {
                      File? imagePicked =
                          await ImagePickerService().pickImage();
                      if (imagePicked != null) {
                        print('uploading');
                        await UploadImageService(targetFile: imagePicked)
                            .uploadProfileUser(user, context);
                      }
                    },
                    child: Text('tes upload'))
              ],
            ),
            Image.asset('assets/images/gwehj.jpg')
          ],
        ),
      ),
    );
  }
}
