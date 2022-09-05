import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicProgressIndicator extends StatelessWidget {
  const DynamicProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CupertinoActivityIndicator(
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      radius: 15,
    ));
  }
}
