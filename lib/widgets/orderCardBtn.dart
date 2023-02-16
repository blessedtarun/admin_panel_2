import 'package:flutter/material.dart';

class OrderCardBtn extends StatelessWidget {
  final String btnName;
  final Color textColor;
  final Color fillColor;
  final Function fn;

  OrderCardBtn({
    @required this.btnName,
    @required this.textColor,
    @required this.fillColor,
    @required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 130,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            width: 1.0,
            color: Colors.black,
          ),
        ),
        child: Text(
          btnName,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
