import 'package:admin_panel/model/item.dart';
import 'package:admin_panel/widgets/productCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Products',
          style: TextStyle(fontSize: 16),
        ),
        toolbarHeight: 50,
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.blue.withOpacity(.9),
                Colors.pink.withOpacity(.9)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              // stops: [0.0, 1.0],
              // tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 50),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.blue.withOpacity(.1),
                  Colors.pink.withOpacity(.1)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                // stops: [0.0, 1.0],
                // tileMode: TileMode.clamp,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, dataSnapshot) {
                return dataSnapshot == null || !dataSnapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.teal),
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.docs[index].data());

                          return ProductCard(
                            model: model,
                          );
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
