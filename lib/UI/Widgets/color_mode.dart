import 'package:flutter/material.dart';

import '../../constants/colors.dart';

Color colorMode(BuildContext context){
  if(MediaQuery.of(context).platformBrightness==Brightness.dark){
    return lightScaffoldColors;
  }else{
    return mobileBackgroundColor;
  }
}


Color colorModeReversed(BuildContext context){
  if(MediaQuery.of(context).platformBrightness==Brightness.dark){
    return mobileBackgroundColor;
  }else{
    return lightScaffoldColors;
  }

}