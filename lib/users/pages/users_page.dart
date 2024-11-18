import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_4asset/users/bloc/user_bloc.dart';
import 'package:teste_4asset/users/components/user_item.dart';
import 'package:teste_4asset/users/models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  final UserBloc userBloc = UserBloc();
  int myIndex = 0;

  @override
  void initState() {
    userBloc.add(UserInitialEvent());
    super.initState();
  }

  Widget body(state) {
    switch (state.runtimeType) {
      case const (UserLoadingState):
        return const Center(
          child: CircularProgressIndicator(),
        );
      case const (UserLoadedSuccessState):
        final actualState = state as UserLoadedSuccessState;
        return ValueListenableBuilder(
          valueListenable: actualState.userBox.listenable(),
          builder: (context, Box<User> box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text("Nenhuma pessoa cadastrada."));
            }
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                myIndex = index;
                final user = box.getAt(index)!;
                return UserItem(
                  user: user,
                  userBloc: userBloc,
                  index: index,
                );
              },
            );
          },
        );
      case const (UserErrorState):
        final actualState = state as UserErrorState;
        return Center(
          child: Text(actualState.error),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: userBloc,
      listenWhen: (previous, current) => current is UserActionState,
      buildWhen: (previous, current) => current is! UserActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: Stack(
            children: [
              Positioned(
                right: 0,
                top: -10,
                  child: IconButton(
                      onPressed: () => userBloc.add(UserInitialEvent()),
                      icon: const Icon(Icons.sync))),
              const Center(child: Text("Cadastro de Pessoas")),
            ],
          )),
          body: body(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              userBloc.add(UserAddButtonPressEvent(
                  userBloc: userBloc, context: context, index: myIndex));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
