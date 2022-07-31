  import 'package:firebase_auth/firebase_auth.dart';

User? loggedUser() {
    if(FirebaseAuth.instance.currentUser == null){
      return null;
    }else{
      return FirebaseAuth.instance.currentUser;
    }
    }



