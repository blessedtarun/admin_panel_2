import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final IconData icons;
  final String text;
  final Color textColor;
  final Function click;

  CustomButton({this.color, this.icons, this.text, this.textColor, this.click});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
      ),
      child: ElevatedButton(
        onPressed: click,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              icons,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
