import '../Widgets/dynamic_progress_indicator.dart';
import '../Widgets/show_date.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/user infos/user_info_cubit.dart';
import '../Widgets/live_comments_view.dart';

class Details extends StatefulWidget {
  final String postId;
  const Details({Key? key, required this.postId}) : super(key: key);
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String? bio;
  Map<String, dynamic>? postData;
  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      postData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  Future<void> getBio() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(postData!['uid'])
        .get()
        .then((value) {
      bio = value.data()!['bio'];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getBio();
  }

  @override
  Widget build(BuildContext context) {
    return postData == null
        ? const DynamicProgressIndicator()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => UserInfoCubit(),
                              child: Profile(
                                uid: postData!['uid'],
                                imageUrl: postData!['profileImage'],
                                name: postData!['userName'],
                                bio: bio,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              postData!["profileImage"],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            postData!['userName'],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Hero(
                        tag: postData!['postID'],
                        child: Image.network(postData!['postURL'])),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${postData!["likes"].length} Likes",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LiveViewComment(
                        postId: postData!['postID'],
                        profileImage: postData!["profileImage"],
                        userName: postData!["userName"]),
                    const SizedBox(height: 10),
                    ShowDate(dateTime: postData!['dateTime'])
                  ],
                ),
              ),
            ),
          );
  }
}
