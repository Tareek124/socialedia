import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../logic/functions/post_comment.dart';
import '../Widgets/color_mode.dart';
import '../Widgets/comments_card.dart';
import '../Widgets/dynamic_progress_indicator.dart';

class CommentsScreen extends StatefulWidget {
  final String imageUrl;
  final String userName;
  final String postID;
  final String uid;
  const CommentsScreen(
      {Key? key,
      required this.imageUrl,
      required this.userName,
      required this.postID,
      required this.uid})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorModeReversed(context),
        title:  Text("Comments",style:TextStyle(color: colorMode(context))),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                      hintText: "Comment As ${widget.userName}",
                      hintStyle: TextStyle(color: colorMode(context),),
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  "Post",
                  style:
                      TextStyle(color: blueColor, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                postComment(
                    postId: widget.postID,
                    text: commentController.text,
                    uid: widget.uid,
                    name: widget.userName,
                    profilePic: widget.imageUrl);

                setState(() {
                  commentController.clear();
                });
              },
            )
          ],
        ),
      )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postID)
            .collection("comments")
            .orderBy("commentTime", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DynamicProgressIndicator();
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return CommentsCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
