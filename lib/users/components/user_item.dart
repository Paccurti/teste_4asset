import 'package:flutter/material.dart';
import 'package:teste_4asset/users/bloc/user_bloc.dart';
import 'package:teste_4asset/users/models/user.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.userBloc,
    required this.index,
  });

  final User user;
  final UserBloc userBloc;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                userBloc.add(UserUpdateButtonPressEvent(
                    user: user, context: context, userBloc: userBloc, index: index));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                userBloc.add(UserDeleteButtonPressEvent(index: index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
