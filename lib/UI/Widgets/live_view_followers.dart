import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../logic/functions/get_user_details.dart';
import '../screens/comments_screen.dart';
import 'dynamic_progress_indicator.dart';

class LiveViewFollowers extends StatelessWidget {
  final String uid;
  final String collection;
  const LiveViewFollowers(
      {Key? key, required this.uid, required this.collection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection(collection)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DynamicProgressIndicator();
            }
            return Text(
              "${snapshot.data!.docs.length}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            );
          }),
    );
  }
}
