// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:Socialedia/UI/Widgets/color_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';
import '../../logic/cubit/signUp/sign_up_cubit.dart';
import '../../logic/functions/image_picker_function.dart';
import '../../logic/functions/validation.dart';
import '../Widgets/png_logo.dart';
import '../Widgets/sign_up_listener.dart';
import '../Widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
  }

  void _callBloc() {
    BlocProvider.of<SignUpCubit>(context).createUser(
        email: _textEditingController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        userName: _userNameController.text,
        file: _image!);
  }

  _pickImage() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        _image = im;
      });
    } else {
      print("Is Denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final svgLogo = PNGLogo(context: context, height: 80);
    final svg = SVGLogo(context: context, height: 64);

    final Validation _signUpValidation = Validation(
      key: _key,
    );

    void isValid() {
      _signUpValidation.validate() ? _callBloc() : print("Not Valid");
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35,
                ),
                SignUpListener().signUpListener(),
                svg.svgLogo(),
                const SizedBox(
                  height: 70,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : const AssetImage("assets/png/avatar.png")
                              as ImageProvider,
                    ),
                    Positioned(
                        bottom: -15,
                        right: -1,
                        child: IconButton(
                            onPressed: _pickImage,
                            icon:  Icon(Icons.add_a_photo,color: colorMode(context),)))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFieldOutline(
                  maxLines: 1,
                  controller: _textEditingController,
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
                CustomTextFieldOutline(
                  maxLines: 1,
                  controller: _userNameController,
                  label: "User Name",
                  icon:  Icon(Icons.person,color: colorMode(context),),
                  isPassword: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFieldOutline(
                  maxLines: 1,
                  controller: _bioController,
                  label: "Your Bio",
                  icon:  Icon(Icons.more,color: colorMode(context),),
                  isPassword: false,
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
                      "Sign Up",
                      style: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? mobileSearchColor
                            : primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Already Have Account",style: TextStyle(color: colorMode(context),),),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Log In"))
                  ],
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
