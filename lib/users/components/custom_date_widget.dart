// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:teste_4asset/users/bloc/user_bloc.dart';

class CustomDateWidget extends StatefulWidget {
  const CustomDateWidget({
    super.key,
    required this.userBloc,
  });
  final UserBloc userBloc;

  @override
  State<CustomDateWidget> createState() => _CustomDateWidgetState();
}

class _CustomDateWidgetState extends State<CustomDateWidget> {
  DateTime birthDate = DateTime.parse('2300-11-22');
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Nascimento:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.066,
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.022)),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.blue.shade300),
                      shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))))),
                  onPressed: () => widget.userBloc.add(UserPickDateEvent(
                      context: context, birthDate: birthDate)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.021,
                                fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      birthDate == DateTime.parse('2300-11-22')
                                          ? 'SELECIONE'
                                          : DateFormat('dd/MM/yyyy')
                                              .format(birthDate),
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height * 0.035,
                      ),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }
}
