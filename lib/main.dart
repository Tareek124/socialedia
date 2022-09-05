// ignore_for_file: avoid_print
import 'package:Socialedia/logic/functions/logged_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'UI/screens/details_post.dart';
import 'constants/colors.dart';
import 'constants/screen_names.dart';
import 'routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRoutes appRoutes = AppRoutes();

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      final Uri deepLink = event.link;
      handleMyLink(deepLink);
      print(
          "=================================deeep link ====================================");
      print(deepLink.toString());
    }).onError((handleError) {
      print(handleError.toString());
    });
  }

  void handleMyLink(Uri url) {
    List<String> seperated = [];
    seperated.addAll(url.path.split('/'));
    print("The Token Is ${seperated[1]}");
    Get.to(() => Details(postId: seperated[1]));
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  final User? user = loggedUser();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'socialedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(scaffoldBackgroundColor: lightScaffoldColors),
      darkTheme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      themeMode: ThemeMode.system,
      onGenerateRoute: appRoutes.generateRoute,
      initialRoute: user == null ? welcomeScreen : mainPage,
    );
  }
}
