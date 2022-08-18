import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:sipaling_sirkel/services/get_user_data.dart';
import 'package:sipaling_sirkel/services/send_user_data_service.dart';
import 'package:sipaling_sirkel/views/homepage.dart';
class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  DatabaseReference database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) { 
            return SignInScreen(
              resizeToAvoidBottomInset: true,
              oauthButtonVariant: OAuthButtonVariant.icon_and_text,
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId:
                        '281086640871-l2b5aefkrihlqk38cvedgtc49dejcg7k.apps.googleusercontent.com')
              ],
              headerBuilder: (context, constraints, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 60,
                    ),
                    Text(
                      'Selamat Datang di sipaling-sirkel',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                );
              },
              footerBuilder: (context, action) {
                return Text(
                  'Ngetes cok',
                  textAlign: TextAlign.center,
                );
              },
              subtitleBuilder: (context, action) {
                return Text(action == AuthAction.signIn
                    ? 'Sipaling-Sirkel\t- Sign In'
                    : 'Sipalin-sirkel\t- Register');
              },
            );
          }
          return HomePage(
            user: snapshot.data!,
          );
        });
  }
}
