import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/screen_names.dart';
import '../../logic/cubit/signUp/sign_up_cubit.dart';
import 'dynamic_progress_indicator.dart';

class SignUpListener {
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
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: title,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  Widget signUpListener() {
    return Row(
      children: [
        BlocListener<SignUpCubit, SignUpState?>(
          listenWhen: (previous, current) {
            return current != previous;
          },
          listener: (context, state) {
            if (state is SignUpError) {
              Navigator.pop(context);
              _showSnackBar(
                  context: context, desc: state.errorMsg, title: "Error");
            } else if (state is SignUpLoading) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _showDialog(context);
                  });
            } else if (state is SignUpSuccess) {
              Navigator.pop(context);

              Navigator.pushReplacementNamed(
                context,
                mainPage,
              );
            }
          },
          child: const SizedBox(),
        ),
      ],
    );
  }
}
