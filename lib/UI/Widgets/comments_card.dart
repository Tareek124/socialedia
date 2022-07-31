import 'package:intl/intl.dart';
import 'color_mode.dart';
import 'package:flutter/material.dart';
import '../../logic/functions/get_user_details.dart';
import '../../logic/functions/like_function.dart';
import 'like_animation.dart';

class CommentsCard extends StatefulWidget {
  Map<String, dynamic> snap;

  CommentsCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.snap['name']}      ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colorMode(context)),
                        ),
                        TextSpan(
                          text: widget.snap['comment'],
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: colorMode(context)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMd()
                          .add_jm()
                          .format(widget.snap['datePublished'].toDate()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['commentLikes'].contains(getUserId()),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['commentLikes'].contains(getUserId())
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () => likeComment(
                    widget.snap['commentId'].toString(),
                    widget.snap['postId'].toString(),
                    getUserId(),
                    widget.snap['commentLikes'],
                  ),
                ),
              ),
              Text(
                "${widget.snap['commentLikes'].length} Like",
              )
            ],
          ),
        ],
      ),
    );
  }
}
