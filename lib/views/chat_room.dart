import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sipaling_sirkel/models/message.dart';
import 'package:sipaling_sirkel/services/message_service.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/variables.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({required this.CircleCode, required this.user});
  String CircleCode;
  User user;
  final Rx<TextEditingController> _messageController =
      TextEditingController().obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
          leadingWidth: MediaQuery.of(context).size.width * 0.25,
          leading: Container(
            color: Colors.red,
            child: Row(
              children: [
                BackButton(),
                CircleAvatar(
                  backgroundColor: Colors.green,
                )
              ],
            ),
          ),
          title: Text('Circle\'s name'),
        ),
        body: StreamBuilder<Object>(
            stream: database.child('circles/${CircleCode}/messages').onValue,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: (snapshot.hasData &&
                            (snapshot.data as DatabaseEvent).snapshot.value !=
                                null)
                        ? ListView(
                            children: messageProvider(snapshot, user, context),
                          )
                        : Center(
                            child: Text('send message plz'),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: SafeArea(
                        child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.green)),
                            child: TextField(
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'input your message\'s here',
                                  border: InputBorder.none),
                              controller: _messageController.value,
                            ),
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Row(
                                            children: [
                                              CircularProgressIndicator(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text('Loading...'),
                                              )
                                            ],
                                          ),
                                        ));
                                await MessageService().SendMessage(
                                    user,
                                    CircleCode,
                                    _messageController.value.value.text);
                                Navigator.pop(context);
                                _messageController.value.clear();
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    )),
                  )
                ],
              );
            }));
  }
}

List<Widget> messageProvider(
    AsyncSnapshot dataStream, User user, BuildContext context) {
  List<Widget> messages = [];
  final listMessage =
      ((dataStream.data as DatabaseEvent).snapshot.value) as List;
  listMessage.forEach((element) {
    final data = Message.RTDB(Map<String, dynamic>.from(element));
    final message = ListTile(
      title: Text(data.uid),
      subtitle: Text(data.message),
    );
    messages.add(Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.only(
          left: user.uid == data.uid
              ? MediaQuery.of(context).size.width * 0.5
              : 0,
          top: 10,
          bottom: 10),
      child: message,
    ));
  });
  return messages;
}
