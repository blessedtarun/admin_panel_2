import 'package:admin_panel/Config/config.dart';
import 'package:admin_panel/widgets/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedOrders extends StatefulWidget {
  @override
  _CompletedOrdersState createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where('isCompleted', isEqualTo: true)
            .snapshots(),
        builder: (context, dataSnapshot) {
          return dataSnapshot == null
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                ))
              : (dataSnapshot.data != null &&  dataSnapshot.data.docs != null) ? ListView.builder(
                  itemBuilder: (context, index) {
                    print('data.docs[index]');
                    print(dataSnapshot.data.docs[index].data());
                    return OrderCard(
                      total: dataSnapshot
                          .data.docs[index]['totalAmount'],
                      adressId:
                          dataSnapshot.data.docs[index]['addressID'],
                      orderTime:
                          dataSnapshot.data.docs[index]['orderTime'],
                      userUId:
                          dataSnapshot.data.docs[index]['orderBy'],
                      url:
                          dataSnapshot.data.docs[index]['invoiceUrl'],
                      status: dataSnapshot
                          .data.docs[index]['isCompleted'],
                      products: dataSnapshot.data.docs[index]['pid'].cast<String>(),
                      quantity: dataSnapshot
                          .data.docs[index]['userCartQuantity']
                          .cast<String>(),
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                ) : Container();
        },
      ),
    );
  }

  circularProgress() {}
}
