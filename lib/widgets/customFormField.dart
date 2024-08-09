// to create reusable components / widgets
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegExp;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.height,
      required this.validationRegExp,
      this.obscureText = false,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 224, 210, 210)),
            // enabledBorder: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Color(0xffe53854),
            //   ),
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(50),
            //   ),
            // ),
            // focusedBorder: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Color(0xffe53854),
            //   ),
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(50),
            //   ),
            // ),
            // border: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Color(0xffe53854),
            //   ),
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(50),
            //   ),
            // ),
            // contentPadding: EdgeInsets.only(left: 20),
            errorStyle: TextStyle(color: Color.fromARGB(255, 250, 78, 66))),
        style: TextStyle(color: Colors.white),
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (value != null && validationRegExp.hasMatch(value)) {
            return null; //succesful validation
          }
          return "Enter a valid ${hintText.toLowerCase()}";
        },
      ),
    );
  }
}
