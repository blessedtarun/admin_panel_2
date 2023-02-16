import 'package:admin_panel/model/item.dart';
import 'package:admin_panel/widgets/productCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FeaturedProductsPage extends StatefulWidget {
  @override
  _FeaturedProductsPageState createState() => _FeaturedProductsPageState();
}

class _FeaturedProductsPageState extends State<FeaturedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Featured Products',
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 100),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where('isFeatured', isEqualTo: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return dataSnapshot == null || !dataSnapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.teal),
                    ))
                  : ListView.builder(
                      physics: ScrollPhysics(),
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
      ),
    );
  }
}
