import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/posts_cubit/posts_cubit_cubit.dart';
import 'dynamic_progress_indicator.dart';

class PostListener {
  _showDialog(BuildContext context) {
    return const AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: DynamicProgressIndicator());
  }

  _showSnackBar(
      {required BuildContext context,
      required String desc,
      required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(desc),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: title,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  Widget postListener() {
    return Row(
      children: [
        BlocListener<PostsCubitCubit, PostsCubitState?>(
          listenWhen: (previous, current) {
            return current != previous;
          },
          listener: (context, state) {
            if (state is PostFailed) {
              Navigator.pop(context);
              _showSnackBar(
                  context: context, desc: state.errorMsg, title: "Error");
            } else if (state is PostLoading) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _showDialog(context);
                  });
            } else if (state is PostSuccess) {
              Navigator.pop(context);

              _showSnackBar(
                  context: context, desc: "Post Uploaded", title: "Success");
            }
          },
          child: const SizedBox(),
        ),
      ],
    );
  }
}
