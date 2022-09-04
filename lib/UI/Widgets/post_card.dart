import '../screens/details_post.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'show_date.dart';
import '../screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../logic/functions/delete_post.dart';
import 'color_mode.dart';
import '../screens/comments_screen.dart';
import '../../logic/cubit/user%20infos/user_info_cubit.dart';
import '../../logic/functions/get_user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/functions/like_function.dart';
import 'like_animation.dart';
import 'live_comments_view.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  String? bio;

  Future<void> getBio() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get()
        .then((value) {
      bio = value.data()!['bio'];
    });
  }

  @override
  void initState() {
    super.initState();
    getBio();
  }

  Future<void> buildDynamicLink(
      {required String image,
      required String postId,
      required String description}) async {
    String url = "http://socialedia.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$postId'),
      // ignore: prefer_const_constructors
      androidParameters: AndroidParameters(
        packageName: "com.tarrrek124abdalla.socialedia",
        minimumVersion: 0,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: description,
          imageUrl: Uri.parse(image),
          title: "Socialedia Post"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    String? desc = dynamicLink.shortUrl.toString();

    await Share.share(
      desc,
      subject: "SocialEdia Post",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState?>(
      builder: (context, state) {
        if (state is UserInfoLoaded) {
          if (state.userModel.followers.contains(widget.snap['uid']) ||
              getUserId() == widget.snap['uid'] ||
              state.userModel.following.contains(widget.snap['uid'])) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => UserInfoCubit(),
                              child: Profile(
                                uid: widget.snap['uid'],
                                imageUrl: widget.snap['profileImage'],
                                name: widget.snap['userName'],
                                bio: bio,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              widget.snap['profileImage'].toString(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.snap['userName'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          widget.snap['uid'].toString() == getUserId()
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ListView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shrinkWrap: true,
                                              children: [
                                                'Delete',
                                              ]
                                                  .map(
                                                    (e) => InkWell(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      16),
                                                          child: Text(e),
                                                        ),
                                                        onTap: () {
                                                          deletePost(
                                                                  postId: widget
                                                                          .snap[
                                                                      'postID'])
                                                              .whenComplete(() {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        }),
                                                  )
                                                  .toList()),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      likePost(
                        widget.snap['postID'].toString(),
                        getUserId(),
                        widget.snap['likes'],
                      );
                      setState(() {
                        isLikeAnimating = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Details(
                                            postId: widget.snap['postID'],
                                          )));
                            },
                            child: Hero(
                              tag: widget.snap['postID'],
                              child: Image.network(
                                widget.snap['postURL'].toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(getUserId()),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes'].contains(getUserId())
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                          onPressed: () => likePost(
                            widget.snap['postID'].toString(),
                            getUserId(),
                            widget.snap['likes'],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.comment_outlined,
                        ),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => CommentsScreen(
                                    uid: getUserId(),
                                    postID: widget.snap['postID'],
                                    imageUrl: state.userModel.imageURL,
                                    userName: state.userModel.userName))),
                      ),
                      InkWell(
                          onTap: () {
                            buildDynamicLink(
                                image: widget.snap['postURL'],
                                postId: widget.snap['postID'],
                                description: widget.snap['description']);
                          },
                          child: const Icon(Icons.share)),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            icon: const Icon(
                              Icons.bookmark_border,
                            ),
                            onPressed: () {}),
                      ))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontWeight: FontWeight.w800),
                            child: Text(
                              '${widget.snap['likes'].length} likes',
                            )),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: colorMode(context)),
                              children: [
                                TextSpan(
                                  text: widget.snap['userName'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.snap['description']}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        LiveViewComment(
                            postId: widget.snap['postID'],
                            profileImage: state.userModel.imageURL,
                            userName: state.userModel.userName),
                        ShowDate(dateTime: widget.snap['dateTime'])
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
