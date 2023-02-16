import 'package:flutter/material.dart';

class CustomAddProduct extends StatelessWidget {
  final String hintname, label;
  final Color colors;
  final TextEditingController txtController;

  CustomAddProduct(
      {this.hintname, this.colors, this.txtController, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: txtController,
        cursorColor: colors,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintname,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
