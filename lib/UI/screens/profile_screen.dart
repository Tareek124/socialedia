import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/screen_names.dart';
import '../../logic/cubit/user%20infos/user_info_cubit.dart';
import '../../logic/functions/follow_users.dart';
import '../../logic/functions/get_user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/functions/sign_out.dart';
import '../Widgets/color_mode.dart';
import '../Widgets/dynamic_progress_indicator.dart';
import '../Widgets/follow_button.dart';

class Profile extends StatefulWidget {
  final String uid;
  String? imageUrl;
  String? name;
  String? bio;
  Profile({Key? key, required this.uid, this.imageUrl, this.name, this.bio})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int postsLength = 0;
  bool isFollowing = false;
  int followers = 0;
  int following = 0;
  var userData = {};

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postsLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            color: colorMode(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserInfoCubit>(context).getUserInfos();
    getData();
  }

  Widget buildText() {
    return Text(
      postsLength.toString(),
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState?>(
      buildWhen: (previous, current) {
        return previous != current;
      },
      builder: (context, state) {
        if (state is UserInfoLoading) {
          return const Scaffold(body: DynamicProgressIndicator());
        } else if (state is UserInfoLoaded) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                widget.uid == getUserId()
                                    ? state.userModel.imageURL
                                    : widget.imageUrl!,
                              ),
                              radius: 45,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postsLength, "posts"),
                                      buildStatColumn(followers, "followers"),
                                      buildStatColumn(following, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      getUserId() == widget.uid
                                          ? FollowButton(
                                              text: 'Sign Out',
                                              backgroundColor:
                                                  colorMode(context),
                                              textColor:
                                                  colorModeReversed(context),
                                              borderColor: colorMode(context),
                                              function: () {
                                                logOut();
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        welcomeScreen);
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: 'Un follow',
                                                  backgroundColor:
                                                      colorMode(context),
                                                  textColor: colorModeReversed(
                                                      context),
                                                  borderColor:
                                                      colorMode(context),
                                                  function: () {
                                                    followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );

                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: 'Follow',
                                                  backgroundColor:
                                                      colorMode(context),
                                                  textColor: colorModeReversed(
                                                      context),
                                                  borderColor:
                                                      colorMode(context),
                                                  function: () {
                                                    followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            widget.uid == getUserId()
                                ? state.userModel.userName
                                : widget.name!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            widget.uid == getUserId()
                                ? state.userModel.bio
                                : widget.bio!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 65.0),
                    child: Divider(
                      color: colorMode(context),
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const DynamicProgressIndicator();
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 2),
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return Image(
                                image: NetworkImage(snap['postURL']),
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
