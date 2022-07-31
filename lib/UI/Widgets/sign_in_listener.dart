import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/screen_names.dart';
import '../../logic/cubit/signIn/sign_in_cubit.dart';
import 'dynamic_progress_indicator.dart';

class SignInListener {
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

  Widget signInListener() {
    return Row(
      children: [
        BlocListener<LogInCubit, LogInState?>(
          listenWhen: (previous, current) {
            return current != previous;
          },
          listener: (context, state) {
            if (state is LogInError) {
              Navigator.pop(context);
              _showSnackBar(context:context, desc:state.errorMsg,title: "Error");
            } else if (state is LogInLoading) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _showDialog(context);
                  });
            } else if (state is LogInSuccessful) {
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
