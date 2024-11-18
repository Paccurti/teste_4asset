import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:teste_4asset/users/models/user.dart';
import 'package:teste_4asset/utils/api.dart';
import 'package:collection/collection.dart';

class SyncManager {
  final Box<User> userBox;
  final Box<Map> pendingOperationsBox;
  final String path = '/exam/v1/persons';

  SyncManager({required this.userBox, required this.pendingOperationsBox});

  Future<void> syncData() async {
    for (var operation in pendingOperationsBox.values) {
      final String action = operation['action'] as String;
      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(operation['userData'] as Map);

      if (action == 'add') {
        await addUserToServer(userData);
      } else if (action == 'update') {
        await updateUserOnServer(userData, operation['id']);
      } else if (action == 'delete') {
        await deleteUserFromServer(userData, userData['id']);
      }
    }
  }

  Future<void> addUserToServer(Map<String, dynamic> userData) async {
    final response =
        await Api.doRequest(path, 'POST', json.encode(userData), null);
    if (response.statusCode == 201) {
      final keyToRemove = pendingOperationsBox.keys.firstWhere(
        (key) {
          final operation = pendingOperationsBox.get(key);
          final equality = const DeepCollectionEquality().equals;
          return operation?['action'] == 'add' &&
              equality(operation?['userData'], userData);
        },
        orElse: () => null,
      );

      if (keyToRemove != null) {
        await pendingOperationsBox.delete(keyToRemove);
      }
    }
  }

  Future<void> updateUserOnServer(
      Map<String, dynamic> userData, int? id) async {
    if (id == null) {
      final getResponse = await Api.doRequest(path, 'GET', null, null);
      final data = jsonDecode(getResponse.body);
      final List<dynamic> users = data['results'];
      id = users.firstWhere(
        (element) {
          return element['email'] == userData['email'];
        },
      )['id'];
    }
    final updateResponse =
        await Api.doRequest('$path/$id', 'PATCH', json.encode(userData), null);
    if (updateResponse.statusCode == 200) {
      final keyToRemove = pendingOperationsBox.keys.firstWhere(
        (key) {
          final operation = pendingOperationsBox.get(key);
          final equality = const DeepCollectionEquality().equals;
          return operation?['action'] == 'update' &&
              equality(operation?['userData'], userData);
        },
        orElse: () => null,
      );

      if (keyToRemove != null) {
        await pendingOperationsBox.delete(keyToRemove);
      }
    }
  }

  Future<void> deleteUserFromServer(
      Map<String, dynamic> userData, int? id) async {
    if (id == null) {
      final getResponse = await Api.doRequest(path, 'GET', null, null);
      final data = jsonDecode(getResponse.body);
      final List<dynamic> users = data['results'];
      id = users.firstWhere(
        (element) {
          return element['email'] == userData['email'];
        },
      )['id'];
    }
    final deleteResponse =
        await Api.doRequest('$path/$id', 'DELETE', null, null);
    if (deleteResponse.statusCode == 204) {
      final keyToRemove = pendingOperationsBox.keys.firstWhere(
        (key) {
          final operation = pendingOperationsBox.get(key);
          return operation?['action'] == 'delete' &&
              (operation?['userData']['id'] == id ||operation?['userData']['id'] == null);
        },
        orElse: () => null,
      );

      if (keyToRemove != null) {
        await pendingOperationsBox.delete(keyToRemove);
      }
    }
  }
}
