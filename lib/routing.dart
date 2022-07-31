
import 'UI/screens/welcome_screen.dart';
import 'logic/cubit/user%20infos/user_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'UI/screens/login_screen.dart';
import 'UI/screens/main_screen.dart';
import 'UI/screens/sign_up_screen.dart';
import 'constants/screen_names.dart';
import 'logic/cubit/signIn/sign_in_cubit.dart';
import 'logic/cubit/signUp/sign_up_cubit.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case loginPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<LogInCubit>(
                  create: (context) => LogInCubit(),
                  child: const LoginScreen(),
                ));

      case signUpPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<SignUpCubit>(
                  create: (context) => SignUpCubit(),
                  child: const SignUpScreen(),
                ));

      case mainPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => UserInfoCubit(),
                  child: const HomeScreen(),
                ));

      case welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

    }
    return null;
  }
}
