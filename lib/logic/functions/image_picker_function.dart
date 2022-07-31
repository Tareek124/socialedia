// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: imageSource);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("User didn't pick an image");
}
