import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/colors.dart';
import 'constants/screen_names.dart';
import 'logic/functions/logged_user.dart';
import 'routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _user = loggedUser();
  final AppRoutes _appRoutes = AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'socialedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(scaffoldBackgroundColor:lightScaffoldColors),
      darkTheme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      themeMode: ThemeMode.system,
      onGenerateRoute: _appRoutes.generateRoute,
      initialRoute: _user == null ? welcomeScreen : mainPage,
    );
  }
}
