import 'package:flutter/cupertino.dart';

class Validation {
  final GlobalKey<FormState> key;

  const Validation({
    required this.key,
  });

  bool validate() {
    if (key.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}


