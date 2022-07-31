import 'package:firebase_auth/firebase_auth.dart';

Future<void> logOut() async {
  await FirebaseAuth.instance.signOut();
}
