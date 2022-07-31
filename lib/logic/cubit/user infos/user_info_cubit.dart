import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_info_model.dart';
import '../../functions/get_user_details.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState?> {
  UserInfoCubit() : super(UserInfoLoading());

  UserModel? model;

  Future<UserModel> getUserInfos() async {
    try {
      await getUserDetails().then((data) {
        emit(UserInfoLoaded(userModel: data));
        model = data;
      });
    } catch (e) {
      print(e);
      emit(UserInfoError(message: e.toString()));
    }
    return model!;
  }
}
