part of 'posts_cubit_cubit.dart';

abstract class PostsCubitState extends Equatable {
  const PostsCubitState();

  @override
  List<Object> get props => [];
}

class PostSuccess extends PostsCubitState {}

class PostFailed extends PostsCubitState {
  final String errorMsg;

  const PostFailed({required this.errorMsg});
}

class PostLoading extends PostsCubitState {}
