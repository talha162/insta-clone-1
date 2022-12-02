import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({Key? key,required this.hintText,required this.textInputType,required this.textEditingController,required this.isPassword}) : super(key: key);
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final border=UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black
        )
    );
    return TextFormField(controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.all(10)
    ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
