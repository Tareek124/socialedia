// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String description;
  final String uid;
  final likes;
  final String userName;
  final String profileImage;
  final String postID;
  final DateTime dateTime;
  final time;
  final String postURL;


  const PostModel({
    required this.dateTime,
    required this.description,
    required this.userName,
    required this.profileImage,
    required this.uid,
    required this.time,
    required this.likes,
    required this.postID,
    required this.postURL,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        "uid": uid,
        "likes": likes,
        "postID": postID,
        "time": time,
        "postURL": postURL,
        'userName': userName,
        'profileImage': profileImage,
        'dateTime': dateTime,
      };

  factory PostModel.fromDocSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        dateTime: snapshot['dateTime'],
        time: snapshot['time'],
        description: snapshot['description'],
        likes: snapshot['likes'],
        postID: snapshot['postID'],
        postURL: snapshot['postURL'],
        uid: snapshot["uid"],
        userName: snapshot['userName'],
        profileImage: snapshot['profileImage']);
  }

  @override
  List<Object> get props {
    return [
      description,
      time,
      uid,
      userName,
      profileImage,
      postID,
      dateTime,
      postURL,
    ];
  }
}
