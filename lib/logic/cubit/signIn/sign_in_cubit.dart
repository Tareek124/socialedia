// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class LogInCubit extends Cubit<LogInState?> {
  LogInCubit() : super(null);

  Future<void> logIn({String? email, String? password}) async {

    emit(LogInLoading());

    try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      emit(LogInSuccessful());

      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LogInError(errorMsg: e.code));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(LogInError(errorMsg: e.code));
        print('Wrong password provided for that user.');
      }
    }
  }
}
