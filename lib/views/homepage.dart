import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:sipaling_sirkel/main_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/create_circle_service.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/join_circle_service.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';

class HomePage extends StatelessWidget {
  final User user;
  HomePage({Key? key, required this.user});
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final _circleCodeController = TextEditingController().obs;
  final _circleNameController = TextEditingController().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => NewCircleAlert(
                        circleNameController: _circleNameController,
                        circleCodeController: _circleCodeController,
                        user: user),
                  );
                },
                child: Text('Create new circle'),
              ),
              SimpleDialogOption(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => JoinCircleAlert(
                      circleNameController: _circleNameController,
                      circleCodeController: _circleCodeController,
                      user: user),
                ),
                child: Text('Join circle'),
              ),
            ],
          ),
        ),
        elevation: 0,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('WELCUM'),
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: database.child('users/${user.uid}/circleList').onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height * 0.2,
            );
          } else {
            if ((snapshot.data! as DatabaseEvent).snapshot.value == null) {
              return Container(
                color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.2,
              );
            } else {
              final listTile = <ListTile>[];
              final listCircle =
                  ((snapshot.data! as DatabaseEvent).snapshot.value) as List;
              listCircle.forEach((val) {
                final data = Map<String, dynamic>.from(val);
                final circle = ListTile(
                  leading: Icon(Icons.plus_one),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_ios_sharp)),
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
      )),
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
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await FlutterFireUIAuth.signOut();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Success to Log Out')));
                      },
                      icon: Icon(Icons.power_settings_new)),
                  ElevatedButton(onPressed: () {}, child: Text('tes upload'))
                ],
              ),
              Image.asset('assets/images/gwehj.jpg')
            ],
          ),
        ),
      ),
    );
  }
}

class JoinCircleAlert extends StatelessWidget {
  const JoinCircleAlert({
    Key? key,
    required Rx<TextEditingController> circleNameController,
    required Rx<TextEditingController> circleCodeController,
    required this.user,
  })  : _circleNameController = circleNameController,
        _circleCodeController = circleCodeController,
        super(key: key);

  final Rx<TextEditingController> _circleNameController;
  final Rx<TextEditingController> _circleCodeController;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        title: Text('Join circle'),
        content: Container(
          child: TextField(
            controller: _circleCodeController.value,
            decoration: InputDecoration(hintText: 'Circle Code'),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _circleCodeController.value.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('Loading...'),
                              )
                            ],
                          ),
                        ));
                String message = await JoinCircleService.joinCircle(
                    user, _circleCodeController.value.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
                _circleCodeController.value.clear();
                _circleNameController.value.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Join')),
        ],
      ),
    );
  }
}

class NewCircleAlert extends StatelessWidget {
  const NewCircleAlert({
    Key? key,
    required Rx<TextEditingController> circleNameController,
    required Rx<TextEditingController> circleCodeController,
    required this.user,
  })  : _circleNameController = circleNameController,
        _circleCodeController = circleCodeController,
        super(key: key);

  final Rx<TextEditingController> _circleNameController;
  final Rx<TextEditingController> _circleCodeController;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        title: Text('Create your own circle\'s'),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _circleNameController.value,
                decoration: InputDecoration(hintText: 'Circle Name'),
              ),
              TextField(
                controller: _circleCodeController.value,
                decoration: InputDecoration(hintText: 'Circle Code'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _circleCodeController.value.clear();
                _circleNameController.value.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('Loading...'),
                              )
                            ],
                          ),
                        ));
                bool isSuccess = await CreateCircleService.postCircle(
                    _circleNameController.value.text,
                    user,
                    _circleCodeController.value.text,
                    null);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isSuccess
                        ? 'Success to create circle'
                        : 'Circle already exist')));
                _circleCodeController.value.clear();
                _circleNameController.value.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Create')),
        ],
      ),
    );
  }
}
