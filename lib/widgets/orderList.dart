import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final String first;
  final String second;

  OrderList({@required this.first, @required this.second});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .6,
            child: Text(
              first,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            child: Text(
              "x" + second,
              style: TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
