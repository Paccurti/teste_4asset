// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.isPassword,
    this.keyboardType,
    this.validator,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    required this.hintText,
    this.focusNode,
    this.onChanged
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String hintText;
  final String? Function(dynamic value)? validator;
  final void Function(dynamic value)? onFieldSubmitted;
  final void Function(dynamic value)? onChanged;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  bool obscureText;
  final bool isPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.hintText, style: const TextStyle(fontSize: 20),),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue.shade300),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.065,
          child: TextFormField(
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
                          onEditingComplete: widget.onEditingComplete,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText,
            controller: widget.controller,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.black54),
              suffixIcon: widget.isPassword == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.obscureText = !widget.obscureText;
                          });
                        },
                        icon: Icon(
                          widget.obscureText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 30,
                        ),
                        color: Colors.white,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
