import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../../functions/get_user_details.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/models/posts_model.dart';
import '../../functions/storage_function.dart';

part 'posts_cubit_state.dart';

class PostsCubitCubit extends Cubit<PostsCubitState?> {
  PostsCubitCubit() : super(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postAPost(
      {required String description,
      required Uint8List file,
      required String uid,
      required String name,
      required String profImage}) async {
    emit(PostLoading());

    String url =
        await StorageMethods().uploadImageToStorage("postPic", file, true);

    String id = const Uuid().v1();

    final postModel = PostModel(
      description: description,
      uid: FirebaseAuth.instance.currentUser!.uid,
      time: FieldValue.serverTimestamp(),
      likes: const [],
      postID: id,
      postURL: url,
      userName: name,
      profileImage: profImage,
      dateTime: DateTime.now(),
    );

    try {
      await _firestore.collection("posts").doc(id).set(postModel.toJson());
      emit(PostSuccess());
    } catch (e) {
      emit(PostFailed(errorMsg: e.toString()));
    }
  }
}
