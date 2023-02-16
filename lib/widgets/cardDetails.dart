import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  final String first;
  final String second;

  CardDetails({@required this.first, @required this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width *.2,
          child: Text(
            first,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width *.65,
          child: Text(
            second,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
