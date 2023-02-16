import 'package:admin_panel/screens/completed_orders.dart';
import 'package:admin_panel/screens/upcoming_orders.dart';
import 'package:admin_panel/widgets/customBottomAppBar.dart';
import 'package:flutter/material.dart';

class AdminOrderDetails extends StatefulWidget {
  const AdminOrderDetails({Key key}) : super(key: key);

  @override
  _AdminOrderDetailsState createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("Orders")),
            bottom: menu(),
          ),
          body: TabBarView(children: [
            UpcomingOrders(),
            CompletedOrders(),
          ]),
        ),
      ),
    );
  }

  Widget menu() {
    return TabBar(
      indicatorColor: Colors.yellowAccent,
      tabs: [
        Tab(
          text: "upcoming",
        ),
        Tab(
          text: "completed",
        ),
      ],
    );
  }
}
