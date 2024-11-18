import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:teste_4asset/users/models/user.dart';
import 'package:teste_4asset/utils/api.dart';

void main() {
  test('Testa o retorno de usuários da API', () async {
    final response = await Api.doRequest('/exam/v1/persons', 'GET', null, null);

    expect(response.statusCode, 200);
    expect(response.body.contains('results'), true);
  });

  test('Testa a adição de usuários na API', () async {
    final user = User(
      id: null,
      email: 'email@teste.com',
      name: 'Teste',
      phone: '123456789',
      birthDate: DateTime.now(),
    );
    final response =
        await Api.doRequest('/exam/v1/persons', 'POST', user.toJson(), null);

    expect(response.statusCode, 201);
  });

  test('Testa a atualização de usuários na API', () async {
    final getResponse =
        await Api.doRequest('/exam/v1/persons', 'GET', null, null);
    final data = jsonDecode(getResponse.body);
    final List<dynamic> users = data['results'];
    final updatedUser = User(
      id: null,
      email: 'emailAlt@teste.com',
      name: 'Teste',
      phone: '123456789',
      birthDate: DateTime.now(),
    );
    final id = users.first['id'];
    final patchResponse = await Api.doRequest(
        '/exam/v1/persons/$id', 'PATCH', updatedUser.toJson(), null);

    expect(patchResponse.statusCode, 200);
  });

  test('Testa a remoção de usuários na API', () async {
    final getResponse =
        await Api.doRequest('/exam/v1/persons', 'GET', null, null);
    final data = jsonDecode(getResponse.body);
    final List<dynamic> users = data['results'];
    final id = users.last['id'];
    final deleteResponse =
        await Api.doRequest('/exam/v1/persons/$id', 'DELETE', null, null);

    expect(deleteResponse.statusCode, 204);
  });
}
