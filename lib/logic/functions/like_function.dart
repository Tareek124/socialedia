// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> likePost(String postId, String uid, List likes) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    if (likes.contains(uid)) {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  } catch (err) {
    print(err.toString());
  }
}

Future<void> likeComment(
    String commentId, String postId, String uid, List likes) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    if (likes.contains(uid)) {
      _firestore
          .collection('posts')
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .update({
        'commentLikes': FieldValue.arrayRemove([uid])
      });
    } else {
      _firestore
          .collection('posts')
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .update({
        'commentLikes': FieldValue.arrayUnion([uid])
      });
    }
  } catch (err) {
    print(err.toString());
  }
}

