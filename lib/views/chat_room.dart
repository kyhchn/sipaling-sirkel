import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sipaling_sirkel/controllers/send_user_data.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/variables.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key}) : super(key: key);
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
        body: Obx((){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: SafeArea(
                    child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.green)),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: 'input your message\'s here',
                            border: InputBorder.none),
                        controller: _messageController.value,
                      ),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.send,
                      color: Colors.green,
                    )
                  ],
                )),
              )
            ],
          );
        }));
  }
}
