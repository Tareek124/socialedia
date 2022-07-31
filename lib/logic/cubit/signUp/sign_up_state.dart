part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String errorMsg;
  SignUpError({required this.errorMsg});
}

class SignUpSuccess extends SignUpState {}
