part of 'user_info_cubit.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}


class UserInfoLoaded extends UserInfoState {
  final UserModel userModel;

  const UserInfoLoaded({required this.userModel});
}

class UserInfoLoading extends UserInfoState {}


class UserInfoError extends UserInfoState{
  final String message;

  const UserInfoError({required this.message});
}
