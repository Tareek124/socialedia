// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/user_info_model.dart';

Future<UserModel> getUserDetails() async {
  FirebaseFirestore _store = FirebaseFirestore.instance;
  FirebaseAuth _user = FirebaseAuth.instance;

  DocumentSnapshot snapshot =
      await _store.collection("users").doc(_user.currentUser!.uid).get();

  return UserModel.fromDocSnapshot(snapshot);
}

String getUserId() {
  FirebaseAuth _user = FirebaseAuth.instance;

  return _user.currentUser!.uid;
}
