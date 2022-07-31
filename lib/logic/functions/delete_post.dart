import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deletePost({required String postId}) async {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  try {
    await fireStore.collection('posts').doc(postId).delete();
  } catch (err) {
    print(err.toString());
  }
}
