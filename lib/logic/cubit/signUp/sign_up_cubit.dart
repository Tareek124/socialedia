// ignore_for_file: avoid_print, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user_info_model.dart';
import '../../functions/get_user_details.dart';
import '../../functions/storage_function.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState?> {
  SignUpCubit() : super(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(
      {required String email,
      required String password,
      required String userName,
      required String bio,
      required Uint8List file}) async {
    emit(SignUpLoading());

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String url = await StorageMethods()
          .uploadImageToStorage("profilePics", file, false);

      final _model = UserModel(
          userName: userName,
          uid: getUserId(),
          email: email,
          bio: bio,
          followers: const [],
          following: const [],
          imageURL: url);

      await _firestore
          .collection("users")
          .doc(getUserId())
          .set(_model.toJson());

      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpError(errorMsg: e.code));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpError(errorMsg: e.code));

        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      emit(SignUpError(errorMsg: e.toString()));
    }
  }
}
