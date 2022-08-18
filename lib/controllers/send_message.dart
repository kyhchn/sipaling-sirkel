import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SendMessage extends GetxController{
  var isSent = false.obs;
  sendMessage(User target, String message) async{
    try {
      // await SendMessageService().postMessage(target, message);
      isSent(true);
      print('succes to send message');
    } catch (e) {
      print(e.toString());
    }finally{
      isSent(false);
    }
  }
}