import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../logic/functions/get_user_details.dart';
import '../screens/comments_screen.dart';
import 'dynamic_progress_indicator.dart';

class LiveViewComment extends StatelessWidget {
  final String postId;
  final String profileImage;
  final String userName;
  const LiveViewComment(
      {Key? key,
      required this.postId,
      required this.profileImage,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(postId)
                .collection("comments")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DynamicProgressIndicator();
              }
              return Text(
                "View All ${snapshot.data!.docs.length} Comments",
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6)),
              );
            }),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => CommentsScreen(
                uid: getUserId(),
                postID: postId,
                imageUrl: profileImage,
                userName: userName)),
      ),
    );
  }
}
