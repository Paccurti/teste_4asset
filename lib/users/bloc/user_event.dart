// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserInitialEvent extends UserEvent {}

class UserDeleteButtonPressEvent extends UserEvent {
  final int index;
  UserDeleteButtonPressEvent({
    required this.index,
  });
}

class UserAddButtonPressEvent extends UserEvent {
  final UserBloc userBloc;
  final BuildContext context;
  final int index;
  UserAddButtonPressEvent({
    required this.userBloc,
    required this.context,
    required this.index,
  });
}

class UserUpdateButtonPressEvent extends UserEvent {
  final UserBloc userBloc;
  final BuildContext context;
  final User user;
  final int index;
  UserUpdateButtonPressEvent({
    required this.user,
    required this.context,
    required this.userBloc,
    required this.index,
  });
}

class UserSubmitButtonPressEvent extends UserEvent {
  final BuildContext context;
  final User user;
  final bool isUpdate;
  final int index;
  UserSubmitButtonPressEvent({
    required this.user,
    required this.isUpdate,
    required this.index,
    required this.context,
  });
}

class UserPickDateEvent extends UserEvent {
  final BuildContext context;
  final DateTime birthDate;
  UserPickDateEvent({
    required this.context,
    required this.birthDate,
  });
}
