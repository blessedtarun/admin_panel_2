import 'dart:developer';

import 'package:admin_panel/DialogBox/errorDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Admin/uploadItems.dart';
// import 'package:e_shop/Authentication/authenication.dart';
// import 'package:e_shop/Widgets/customTextField.dart';

import 'package:admin_panel/screens/admin_panel.dart';
import 'package:admin_panel/widgets/customButton.dart';
import 'package:admin_panel/widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  loginAdmin() async {
    log('cam here');
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _adminIDTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((value) {
      log('here in value');
      FirebaseFirestore.instance
          .collection("admin")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((snapshot) {
        log(snapshot.toString());
        if (snapshot != null) if (snapshot.data()["id"] !=
            FirebaseAuth.instance.currentUser.uid) {
          print("id incorrect");
          FirebaseAuth.instance.signOut();
        } else {
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   content: Text("Welcome Admin, " + result.data["name"]),
          // ));
          print("welcome");
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (_) => AdminPanel());
          Navigator.pushReplacement(context, route);
        }
        else {
          FirebaseAuth.instance.signOut();
          log('user admin not found');
        }
      }).onError((error, stackTrace) {
        log(error.toString());
        FirebaseAuth.instance.signOut();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          // decoration: new BoxDecoration(
          //   gradient: new LinearGradient(
          //     colors: [Colors.deepOrangeAccent, Colors.deepOrange],
          //     begin: const FractionalOffset(0.0, 0.0),
          //     end: const FractionalOffset(1.0, 0.0),
          //     stops: [0.0, 1.0],
          //     tileMode: TileMode.clamp,
          //   ),
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "images/admin.png",
                  height: 240.0,
                  width: 240.0,
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "Welcome,",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "Admin",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIDTextEditingController,
                      data: Icons.person,
                      hintText: "Admin ID",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock,
                      hintText: "Enter Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              CustomButton(
                color: Theme.of(context).primaryColor,
                text: 'Login',
                textColor: Colors.white,
                click: () {
                  _adminIDTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginAdmin()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please fill all fields!",
                            );
                          });
                  //loginAdmin();
                },
              ),
              // TextButton(
              //     onPressed: () {
              //       _adminIDTextEditingController.text.isNotEmpty &&
              //               _passwordTextEditingController.text.isNotEmpty
              //           ? loginAdmin()
              //           : showDialog(
              //               context: context,
              //               builder: (c) {
              //                 return ErrorAlertDialog(
              //                   message: "Please fill all fields!",
              //                 );
              //               });
              //       //loginAdmin();
              //     },
              //     child: Text("Login")),
              // RawMaterialButton(
              //   onPressed: () {},
              //   shape: const StadiumBorder(),
              //   fillColor: Colors.orange,
              //   child: Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Container(
              //       height: 40.0,
              //       child: Text(
              //         "Login",
              //         maxLines: 1,
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
              // RaisedButton(
              //   onPressed: () {
              //     //_adminIDTextEditingController.text.isNotEmpty &&
              //     //         _passwordTextEditingController.text.isNotEmpty
              //     //     ? loginAdmin()
              //     //     : showDialog(
              //     //         context: context,
              //     //         builder: (c) {
              //     //           return ErrorAlertDialog(
              //     //             message: "Please fill all fields!",
              //     //           );
              //     //         });
              //     // loginAdmin();
              //   },
              //   color: Colors.white,
              //   child: Text(
              //     "Login",
              //     style: TextStyle(color: Colors.green),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
