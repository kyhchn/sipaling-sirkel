import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:sipaling_sirkel/models/user_database.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';

class SendUserData extends GetxController {
  var isLoading = false.obs;
  sendUserData(User target, DatabaseReference database) async {
    UserDatabase data = await GetUserData.getUserData(target);
    try {
      isLoading(true);
      await SendUserDataService.postUserData(data, database);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
