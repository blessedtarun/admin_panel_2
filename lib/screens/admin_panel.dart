// <<<<<<< HEAD
// =======
// // import 'dart:ffi';

// >>>>>>> 694dafac08071b00949d60e4b39efc5dace8fe46
import 'dart:developer';

import 'package:admin_panel/screens/adminOrderDetails.dart';
import 'package:admin_panel/screens/bannerImage.dart';
import 'package:admin_panel/screens/featuredProductScreen.dart';
import 'package:admin_panel/screens/login.dart';
import 'package:admin_panel/screens/products.dart';
import 'package:admin_panel/screens/uploadItems.dart';
import 'package:admin_panel/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("LogOut"),
      onPressed: () {
        log('logout pressed');
        FirebaseAuth.instance.signOut();
        // SystemNavigator.pop();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => AdminSignInScreen()),
        //   ModalRoute.withName('/'),
        // );
        Navigator.of(context)
    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

        // Route route = MaterialPageRoute(builder: (_) => AdminSignInScreen());
        // Navigator.pushReplacement(context, route);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("LogOut"),
      content: Text("Would you like to logout from Arora Admin Panel?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shadowColor: Colors.transparent,
          title: Text('Admin Panel',
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 20),
              )),
          leading: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                showAlertDialog(context);
              }),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black,
                ),
                onPressed: () {})
          ],
          backgroundColor: Colors.transparent,
        ),
        body: AdminPanelScreen(),
      ),
    );
  }
}

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    final mheight = MediaQuery.of(context).size.height;
    final mwidth = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/admin_bg.png"), fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: mheight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Text('Welcome Tarun',
                    style: GoogleFonts.aclonica(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 20),
                    )),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: SizedBox(
                  height: mheight * .10,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .snapshots(),
                        builder: (_, snapshot) {
                          //print(snapshot.data.documents.length);
                          return (!snapshot.hasData)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                        builder: (_) => AdminOrderDetails());
                                    Navigator.push(context, route);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          width: mwidth * .35,
                                          height: mwidth * .25,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                // stops: [],
                                                colors: [
                                                  Colors.blue.withOpacity(.4),
                                                  Colors.pink.withOpacity(.4)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            'Orders',
                                            style: GoogleFonts.abel(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .4,
                                                  fontSize: 15),
                                            ),
                                          )),
                                      if (snapshot.hasData)
                                        Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              height: 18,
                                              width: 18,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(.6),
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ))
                                    ],
                                  ),
                                );
                        }),
                    InkWell(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (_) => BannerImage());
                        Navigator.push(context, route);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: mwidth * .35,
                          height: mwidth * .25,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                // stops: [],
                                colors: [
                                  Colors.blue.withOpacity(.4),
                                  Colors.pink.withOpacity(.4)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Banners',
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .4,
                                  fontSize: 15),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 20,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProductsPage()));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: mwidth * .35,
                          height: mwidth * .25,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                // stops: [],
                                colors: [
                                  Colors.blue.withOpacity(.4),
                                  Colors.pink.withOpacity(.4)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Products',
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .4,
                                  fontSize: 15),
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FeaturedProductsPage()));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: mwidth * .35,
                          height: mwidth * .25,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                // stops: [],
                                colors: [
                                  Colors.blue.withOpacity(.4),
                                  Colors.pink.withOpacity(.4)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Featured',
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .4,
                                  fontSize: 15),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 20,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (_) => UploadPage());
                      Navigator.push(context, route);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: mwidth * .40,
                        height: mwidth * .25,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              // stops: [],
                              colors: [
                                Colors.blue.withOpacity(.4),
                                Colors.pink.withOpacity(.4)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Add new Products',
                          style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .4,
                                fontSize: 15),
                          ),
                        )),
                  ),
                ),
              ),

              // CustomButton(
              //   color: Colors.deepOrange,
              //   //icons: Icons.backspace,
              //   text: 'Orders',
              //   textColor: Colors.white,
              //   click: () {
              //     Route route =
              //         MaterialPageRoute(builder: (_) => AdminOrderDetails());
              //     Navigator.push(context, route);
              //   },
              // ),
              // SizedBox(
              //   height: 25.0,
              // ),
              // CustomButton(
              //   color: Colors.deepOrange,
              //   //icons: Icons.backspace,
              //   text: 'Products',
              //   textColor: Colors.white,
              //   click: () {
              //     Route route = MaterialPageRoute(builder: (_) => ProductsPage());
              //     Navigator.push(context, route);
              //   },
              // ),
              // SizedBox(
              //   height: 25.0,
              // ),
              // CustomButton(
              //   color: Colors.grey[200],
              //   text: 'Add New Product',
              //   textColor: Colors.black,
              //   click: () {
              //     Route route = MaterialPageRoute(builder: (_) => UploadPage());
              //     Navigator.push(context, route);
              //   },
              // ),
              // SizedBox(
              //   height: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
