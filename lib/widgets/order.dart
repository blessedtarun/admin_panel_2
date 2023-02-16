import 'dart:core';
import 'dart:io';

import 'package:admin_panel/Config/pdf_api.dart';
import 'package:admin_panel/screens/viewCartItems.dart';
import 'package:admin_panel/widgets/cardDetails.dart';
import 'package:admin_panel/widgets/orderCardBtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:math';

class OrderCard extends StatefulWidget {
  final double total;
  final String adressId;
  final String userUId;
  final String orderTime;
  final bool status;
  final List<String> products;
  final List<String> quantity;
  final String url;

  OrderCard({
    @required this.total,
    @required this.adressId,
    @required this.userUId,
    @required this.orderTime,
    @required this.status,
    @required this.products,
    @required this.quantity,
    @required this.url,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String name = "";
  String phone = "";
  String faddress = "";
  String saddress = "";

  @override
  void initState() {
    // TODO: implement initState
    print('widget.products');
    print(widget.products);
    print(widget.quantity);
    changes();

    super.initState();
  }

  changes() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUId)
        .collection("userAddress")
        .doc(widget.adressId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data);
        setState(() {
          name = documentSnapshot['name'];
          phone = documentSnapshot['phoneNumber'];
          faddress = documentSnapshot['flatNumber'] +
              ", " +
              documentSnapshot['city'];
          saddress = documentSnapshot['state'] +
              ", " +
              documentSnapshot['pincode'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 5.0), //(x,y)
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Cart Total: ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.total.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.download_outlined),
                  onPressed: () {
                    openPdf(context);
                  },
                ),
              ),
            ],
          ),
          CardDetails(first: 'Name:', second: name),
          CardDetails(first: 'Phone No.: ', second: phone),
          CardDetails(first: 'Address: ', second: faddress),
          CardDetails(first: '         ', second: saddress),
          CardDetails(
              first: 'Date & Time: ',
              second: DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.orderTime)))),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OrderCardBtn(
                fn: () {
                  print('widget.products');
                  print(widget.products);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderDetails(
                              products: widget.products,
                              quantity: widget.quantity)));
                },
                btnName: 'View Cart Items',
                textColor: Colors.black,
                fillColor: Colors.white,
              ),
              OrderCardBtn(
                fn: () {
                  changeStatus(context);
                },
                btnName: 'Change Status',
                textColor: Colors.white,
                fillColor: Colors.deepOrangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  openPdf(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "want to vie invoice",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  PdfApi.openFileFromUrl(widget.url);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  changeStatus(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "want change Order Status",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('orders')
                      .doc(widget.userUId + widget.orderTime)
                      .update({"isCompleted": !widget.status}).then(
                          (value) {});
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel!",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<File> urlToFile(String pdfUrl) async {
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.pdf');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(pdfUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }
}
