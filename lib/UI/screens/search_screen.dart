import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/user infos/user_info_cubit.dart';
import '../Widgets/color_mode.dart';
import '../Widgets/dynamic_progress_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorModeReversed(context),
          title: Form(
            child: TextFormField(
              style: TextStyle(color: colorMode(context),),
              controller: searchController,
              decoration:
                   InputDecoration(labelText: 'Search for a user...',labelStyle: TextStyle(color: colorMode(context),)),
              onFieldSubmitted: (String _) {
                setState(() {
                  isSearching = true;
                });
                print(_);
              },
            ),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where(
                'username',
                isGreaterThanOrEqualTo: searchController.text,
              )
              .get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const DynamicProgressIndicator();
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => UserInfoCubit(),
                        child: Profile(
                          uid: snapshot.data!.docs[index]['uid'],
                          imageUrl: snapshot.data!.docs[index]['url'],
                          name: snapshot.data!.docs[index]['username'],
                          bio: snapshot.data!.docs[index]['bio'],
                        ),
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['url'],
                      ),
                      radius: 16,
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                      style: TextStyle(color: colorMode(context),),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

