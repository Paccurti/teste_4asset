// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_4asset/users/bloc/user_bloc.dart';
import 'package:teste_4asset/users/components/custom_date_widget.dart';
import 'package:teste_4asset/users/components/custom_text_form_field.dart';

import 'package:teste_4asset/users/models/user.dart';

class UserFormItem extends StatefulWidget {
  const UserFormItem({
    super.key,
    this.user,
    required this.userBloc,
    required this.index,
  });
  final User? user;
  final UserBloc userBloc;
  final int index;

  @override
  State<UserFormItem> createState() => _UserFormItemState();
}

class _UserFormItemState extends State<UserFormItem> {
  final formKey = GlobalKey<FormState>();
  DateTime birthDate = DateTime.parse('2300-11-22');
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    if (widget.user != null) {
      emailController = TextEditingController(text: widget.user!.email);
      nameController = TextEditingController(text: widget.user!.name);
      phoneController = TextEditingController(text: widget.user!.phone);
      birthDate = widget.user!.birthDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: widget.userBloc,
      listener: (context, state) {
        if (state is UserPickDateState) {
          setState(() {
            birthDate = state.birthDate;
          });
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: emailController,
                  obscureText: false,
                  isPassword: false,
                  hintText: 'E-mail',
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Informe seu e-mail!';
                    } else if (!value.contains('@')) {
                      return 'Informe um e-mail válido!';
                    } else if (value == widget.user?.email) {
                      return 'O e-mail deve ser alterado!';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: nameController,
                  obscureText: false,
                  isPassword: false,
                  hintText: 'Nome',
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Informe seu nome!';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: phoneController,
                  obscureText: false,
                  isPassword: false,
                  hintText: 'Telefone (com DDD)',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Informe seu telefone!';
                    }
                    return null;
                  },
                ),
                CustomDateWidget(userBloc: widget.userBloc),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15))),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.blue.shade300,
                        ),
                      ),
                      onPressed: () {
                        final isValid =
                            formKey.currentState?.validate() ?? false;
                        if (!isValid) return;
                        final user = User(
                            id: widget.user?.id,
                            email: emailController.text,
                            name: nameController.text,
                            phone: phoneController.text,
                            birthDate: birthDate);
                        widget.user == null
                            ? widget.userBloc.add(UserSubmitButtonPressEvent(
                                user: user,
                                isUpdate: false,
                                index: widget.index,
                                context: context))
                            : widget.userBloc.add(UserSubmitButtonPressEvent(
                                user: user,
                                isUpdate: true,
                                index: widget.index,
                                context: context));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
