import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<void> postComment(
    {required String postId,
    required String text,
    required String uid,
    required String name,
    required String profilePic}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    if (text.isNotEmpty) {
      String commentId = const Uuid().v1();
      firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'profilePic': profilePic,
        'name': name,
        'uid': uid,
        'commentTime': FieldValue.serverTimestamp(),
        'postId':postId,
        'comment': text,
        'commentId': commentId,
        'datePublished': DateTime.now(),
        "commentLikes":[],
      });
    } else {
      print("Field Is Empty");
    }
  } catch (err) {
    print(err.toString());
  }
}
