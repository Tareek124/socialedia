import 'package:flutter/material.dart';

import '../../constants/screen_names.dart';
import '../Widgets/color_mode.dart';
import '../Widgets/png_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pngLogo = PNGLogo(context: context, height: 165);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                    )),
                Expanded(flex: 0, child: pngLogo.pngLogo()),
                // Expanded(flex: 1, child: svgLogo.svgLogo()),
                const SizedBox(
                  height: 130,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, loginPage);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: colorMode(context),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: colorModeReversed(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, signUpPage);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: colorMode(context),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: colorModeReversed(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
