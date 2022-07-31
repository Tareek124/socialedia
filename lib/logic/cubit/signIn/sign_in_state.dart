part of 'sign_in_cubit.dart';

@immutable
abstract class LogInState {}


class LogInLoading extends LogInState{}


class LogInSuccessful extends LogInState{
}


class LogInError extends LogInState{
  final String errorMsg;

  LogInError({required this.errorMsg});
}

