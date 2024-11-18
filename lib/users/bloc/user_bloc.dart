import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_4asset/users/components/user_form_item.dart';
import 'package:teste_4asset/users/models/user.dart';
import 'package:teste_4asset/users/services/sync_manager.dart';
import 'package:teste_4asset/utils/api.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitialState()) {
    on<UserInitialEvent>(userInitialEvent);
    on<UserDeleteButtonPressEvent>(userDeleteButtonPressEvent);
    on<UserAddButtonPressEvent>(userAddButtonPressEvent);
    on<UserUpdateButtonPressEvent>(userUpdateButtonPressEvent);
    on<UserPickDateEvent>(userPickDateEvent);
    on<UserSubmitButtonPressEvent>(userSubmitButtonPressEvent);
  }

  late Box<User> userBox;
  late Box<Map> pendingOperationsBox;
  late SyncManager syncManager;

  FutureOr<void> userInitialEvent(
      UserInitialEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    userBox = Hive.box<User>('users');
    pendingOperationsBox = Hive.box<Map>('pendingOperations');
    syncManager = SyncManager(
        userBox: userBox, pendingOperationsBox: pendingOperationsBox);
    await syncManager.syncData();
    await getUsers(emit);
  }

  FutureOr<void> userDeleteButtonPressEvent(
      UserDeleteButtonPressEvent event, Emitter<UserState> emit) async {
    await deleteUser(event.index);
    emit(UserLoadedSuccessState(userBox: userBox));
  }

  FutureOr<void> userAddButtonPressEvent(
      UserAddButtonPressEvent event, Emitter<UserState> emit) async {
    showAlertDialog(event.context, event.userBloc, null, event.index);
  }

  FutureOr<void> userUpdateButtonPressEvent(
      UserUpdateButtonPressEvent event, Emitter<UserState> emit) async {
    showAlertDialog(event.context, event.userBloc, event.user, event.index);
  }

  FutureOr<void> userSubmitButtonPressEvent(
      UserSubmitButtonPressEvent event, Emitter<UserState> emit) async {
    if (event.isUpdate == true) {
      editUser(event.index, event.user);
    } else {
      addUser(event.user);
    }
    Navigator.of(event.context).pop();
    emit(UserLoadedSuccessState(userBox: userBox));
  }

  FutureOr<void> userPickDateEvent(
      UserPickDateEvent event, Emitter<UserState> emit) async {
    final date = await pickDate(event.context, event.birthDate);
    emit(UserPickDateState(birthDate: date ?? event.birthDate));
  }

  Future<void> getUsers(Emitter<UserState> emit) async {
    final response = await Api.doRequest('/exam/v1/persons', 'GET', null, null);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> dynamicList = jsonResponse['results'] as List;
      List<User> userList = dynamicList.map((i) => User.fromMap(i)).toList();
      if (userList.isNotEmpty) {
        final filteredUserList = userList
            .where((user) => !userBox.values
                .any((existingUser) => existingUser.email == user.email))
            .toList();
        for (var user in filteredUserList) {
          await userBox.add(user);
        }
        emit(UserLoadedSuccessState(userBox: userBox));
      } else {
        emit(UserErrorState(error: 'Lista Vazia!'));
      }
    } else {
      final String error = jsonResponse['message'] as String;
      emit(UserErrorState(error: error));
    }
  }

  Future<void> addUser(User user) async {
    userBox.add(user);
    pendingOperationsBox.add({'action': 'add', 'userData': user.toMap()});
    syncManager.syncData();
  }

  Future<void> editUser(int index, User user) async {
    userBox.putAt(index, user);
    pendingOperationsBox.add({'action': 'update', 'userData': user.toMap(), 'id': user.id});
    syncManager.syncData();
  }

  Future<void> deleteUser(int index) async {
    final user = userBox.getAt(index);
    userBox.deleteAt(index);
    pendingOperationsBox.add({
      'action': 'delete',
      'userData': {'id': user?.id, 'email': user?.email}
    });
    syncManager.syncData();
  }

  Future<DateTime?> pickDate(
    BuildContext context,
    DateTime birthDate,
  ) async {
    return showDatePicker(
      context: context,
      initialDate: birthDate == DateTime.parse('2300-11-22')
          ? DateTime.now()
          : birthDate,
      firstDate:
          DateTime.now().subtract(const Duration(days: 999999999999999999)),
      lastDate: DateTime.now(),
    );
  }

  void showAlertDialog(
      BuildContext context, UserBloc userBloc, User? user, int index) {
    final alertDialog = AlertDialog(
      content: UserFormItem(
        userBloc: userBloc,
        user: user,
        index: index,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
