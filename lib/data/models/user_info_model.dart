// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userName;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String imageURL;

  const UserModel({
    required this.userName,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.imageURL,
  });

  Map<String, dynamic> toJson() => {
        "username": userName,
        "uid": uid,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "url": imageURL
      };

  factory UserModel.fromDocSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        userName: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        imageURL: snapshot['url']);
  }

  @override
  List<Object> get props {
    return [
      userName,
      uid,
      email,
      bio,
      followers,
      following,
      imageURL,
    ];
  }
}
