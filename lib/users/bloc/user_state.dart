// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitialState extends UserState {}

abstract class UserActionState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedSuccessState extends UserState {
  final Box<User> userBox;
  UserLoadedSuccessState({
    required this.userBox,
  });
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState({
    required this.error,
  });
}

class UserDeleteButtonState extends UserActionState {}

class UserAddButtonState extends UserActionState {}

class UserUpdateButtonState extends UserActionState {}

class UserSubmitButtonState extends UserActionState {}

class UserPickDateState extends UserActionState {
  final DateTime birthDate;
  UserPickDateState({
    required this.birthDate,
  });
}
