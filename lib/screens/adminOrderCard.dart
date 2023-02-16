// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Admin/adminOrderDetails.dart';
// import 'package:e_shop/Config/config.dart';
// import 'package:e_shop/Models/item.dart';
// import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';

// import '../Store/storehome.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  // final List<DocumentSnapshot> data;
  var dataorder;
  final String orderId;
  final String addressId;
  final String orderedBy;

  AdminOrderCard(
      {Key key,
      this.dataorder,
      // this.data,
      this.orderId,
      this.itemCount,
      this.addressId,
      this.orderedBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Route route;
        // if (counter == 0) {
        //   counter = counter + 1;
        //   route = MaterialPageRoute(
        //       builder: (c) => AdminOrderDetails(
        //             orderId: orderId,
        //             orderedBy: orderedBy,
        //             addressId: addressId,
        //           ));
        // }
        // Navigator.push(context, route);
      },
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.deepOrangeAccent, Colors.deepOrange],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          // itemBuilder: (c, index) {
          //   // ItemModel model = ItemModel.fromJson(data[index].data);
          //   // return sourceOrderInfoAdmin(model, context,index);
          // },
        ),
      ),
    );
  }

  Widget sourceOrderInfoAdmin(
      /*ItemModel model*/ BuildContext context,
      int index,
      {Color background}) {
    // width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[300],
      height: 170.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          // Image.network(
          //   model.thumbnailUrl,
          //   width: 180.0,
          // ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'ABC',
                          // model.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'ABC',
                          // model.shortInfo,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          (dataorder == null) ? "1" : dataorder[index],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Price: ",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                "₹ ",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '123',
                                // (model.price*int.parse(dataorder[index])).toString(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Divider(
                  height: 5.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
