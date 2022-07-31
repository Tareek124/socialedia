import '../Widgets/color_mode.dart';
import '../Widgets/dynamic_progress_indicator.dart';
import '../Widgets/png_logo.dart';
import '../Widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final SVGLogo svgLogo = SVGLogo(height: 27, context: context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorModeReversed(context),
        title: svgLogo.svgLogo(),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").orderBy('time',descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DynamicProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ));
          }),
    );
  }
}
