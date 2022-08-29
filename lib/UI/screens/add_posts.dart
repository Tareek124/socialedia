import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/user_info_model.dart';
import '../../logic/functions/get_user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../logic/cubit/posts_cubit/posts_cubit_cubit.dart';
import '../../logic/functions/storage_function.dart';
import '../Widgets/color_mode.dart';
import '../Widgets/post_listener.dart';
import '../../logic/functions/image_picker_function.dart';
import '../Widgets/text_field_input.dart';

class AddPosts extends StatefulWidget {
  final String name;
  final String imageUrl;
  const AddPosts({
    required this.name,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  Uint8List? _imageFile;
  String? imageUrl;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  UserModel? _userModel;

  Future<UserModel> getUserInfo() async {
    return await getUserDetails().then((value) => _userModel = value);
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: colorModeReversed(context),
          title: const Text(
            'Create a Post',
            style: TextStyle(),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo', style: TextStyle()),
                onPressed: () async {
                  Navigator.pop(context);
                  var permissions = await Permission.camera.request();
                  if (permissions.isGranted) {
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _imageFile = file;
                    });
                    imageUrl = await StorageMethods()
                        .uploadImageToStorage("postPic", _imageFile!, true);
                  } else {
                    print("Denied");
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text('Choose from Gallery',
                    style: TextStyle(
                      color: colorMode(context),
                    )),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var permissions = await Permission.storage.request();
                  if (permissions.isGranted) {
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _imageFile = file;
                    });
                    imageUrl = await StorageMethods()
                        .uploadImageToStorage("postPic", _imageFile!, true);
                  } else {
                    print("Denied");
                  }
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel", style: TextStyle()),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile == null
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _selectImage(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Post Image  ",
                          style: TextStyle(
                            fontSize: 25,
                            color: colorMode(context),
                          ),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.image,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              foregroundColor: colorMode(context),
              backgroundColor: colorModeReversed(context),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Post to ${_userModel!.userName}',
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_userModel!.imageURL),
                    radius: 18,
                  )
                ],
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    BlocProvider.of<PostsCubitCubit>(context)
                        .postAPost(
                          description: _descriptionController.text,
                          imageUrl: imageUrl!,
                          uid: getUserId(),
                          name: widget.name,
                          profImage: widget.imageUrl,
                        )
                        .then((value) => {clearImage()});
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PostListener().postListener(),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image(image: MemoryImage(_imageFile!, scale: 0.5)),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFieldOutline(
                      maxLines: 2,
                      controller: _descriptionController,
                      label: "Description",
                      icon: const Icon(Icons.text_fields_rounded),
                      isPassword: false,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
