// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:Socialedia/UI/Widgets/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/colors.dart';
import '../../constants/screen_names.dart';
import '../../logic/cubit/signIn/sign_in_cubit.dart';
import '../../logic/functions/validation.dart';
import '../Widgets/png_logo.dart';
import '../Widgets/sign_in_listener.dart';
import '../Widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _callBloc() {
    BlocProvider.of<LogInCubit>(context).logIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final svgLogo = PNGLogo(context: context, height: 80);
    final svg = SVGLogo(context: context, height: 64);

    final Validation _validate = Validation(key: _key);

    void isValid() {
      _validate.validate() ? _callBloc() : print("Not Valid");
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 0,
                  )),
              SignInListener().signInListener(),
              svg.svgLogo(),
              const SizedBox(
                height: 50,
              ),
              CustomTextFieldOutline(
                maxLines: 1,
                controller: _emailController,
                label: "Email",
                icon:  Icon(Icons.email,color: colorMode(context),),
                isPassword: false,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextFieldOutline(
                maxLines: 1,
                controller: _passwordController,
                label: "Password",
                icon:  Icon(Icons.password,color: colorMode(context),),
                isPassword: true,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: isValid,
                child: Container(
                  width: 180,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? primaryColor
                        : mobileBackgroundColor,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: colorModeReversed(context),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't Have Account",style: TextStyle(color: colorMode(context)),),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signUpPage);
                      },
                      child: const Text("SignUp"))
                ],
              ),
              const Expanded(flex: 1, child: SizedBox())
            ],
          ),
        ),
      )),
    );
  }
}
