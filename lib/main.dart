import 'package:admin_panel/screens/adminOrderDetails.dart';
import 'package:admin_panel/screens/admin_panel.dart';
import 'package:admin_panel/screens/login.dart';
import 'package:admin_panel/screens/uploadItems.dart';
import 'package:admin_panel/screens/products.dart';
import 'package:admin_panel/screens/viewCartItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// const AndroidNotificationChanner channel = AndroidNotificationChannel(
//   'high_importance_channel',

// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    return MaterialApp(
      title: 'Arora Brush',
      // initialRoute: '/',
      routes: {
        '/login': (context) => AdminSignInScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: (FirebaseAuth.instance.currentUser == null)
          ? AdminSignInScreen()
          : AdminPanel(),
    );
  }
}
