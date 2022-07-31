import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'color_mode.dart';

import '../../constants/colors.dart';

class PNGLogo {
  final BuildContext context;
  final double height;
  PNGLogo({required this.context, required this.height});

  Widget pngLogo() {
    return Image.asset(
          "assets/png/socialedia.png",
      height: height,
    );
  }
}

class SVGLogo {
  final BuildContext context;
  final double height;

  SVGLogo({required this.context, required this.height});

  Widget svgLogo() {
    return SvgPicture.asset(
      "assets/svg/BlckTxt.svg",
      height: height,
      color: colorMode(context),
    );
  }
}
