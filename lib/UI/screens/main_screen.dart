import 'search_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';
import '../../logic/cubit/user%20infos/user_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/posts_cubit/posts_cubit_cubit.dart';
import '../Widgets/color_mode.dart';
import 'add_posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController pageController; // for tabs animation
  String? name;
  String? url;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserInfoCubit>(context).getUserInfos().then((value) {
      name = value.userName;
      url = value.imageURL;
    });
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserInfoCubit, UserInfoState?>(
        builder: (context, state) {
          if (state is UserInfoLoaded) {
            return PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  const FeedScreen(),
                  const SearchScreen(),
                  BlocProvider(
                    create: (context) => PostsCubitCubit(),
                    child: AddPosts(
                      name: name!,
                      imageUrl: url!,
                    ),
                  ),
                  Profile(
                    uid: state.userModel.uid,
                  )
                ]);
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: colorMode(context),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: colorMode(context),
              ),
              label: 'Home',
              backgroundColor: colorModeReversed(context)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: colorMode(context),
              ),
              label: 'Search',
              backgroundColor: colorModeReversed(context)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: colorMode(context),
              ),
              label: 'Post',
              backgroundColor: colorModeReversed(context)),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: colorMode(context),
            ),
            label: 'Profile',
            backgroundColor: colorModeReversed(context),
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}