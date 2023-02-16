import 'package:admin_panel/widgets/cardDetails.dart';

import 'package:admin_panel/widgets/orderList.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  // const OrderDetails({ Key? key }) : super(key: key);
  final List<String> products;
  final List<String> quantity;
  OrderDetails({@required this.products, @required this.quantity});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Order Details',
          ),
        ),
        body: ListView.builder(
          itemCount: widget.quantity.length,
          itemBuilder: (context, index) {
            return OrderList(
                first: widget.products[index],
                second: widget.quantity[index]);
          },
        ));
  }
}
