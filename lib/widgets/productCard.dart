import 'package:admin_panel/model/item.dart';
import 'package:admin_panel/screens/uploadItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ItemModel model;
  final int index;
  ProductCard({this.model, this.index});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  _deleteAlreadyExistImageDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('products')
            .doc(widget.model.pid)
            .delete();
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          child: Text(
            'Delete Product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          height: 50,
          width: 60,
        ),
      ),
      content: Text("Would you like to delete the following Product?"),
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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 7.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 200.0,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,

                    child: 
                    widget.model.thumbnailUrl.length > 0 ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.model.thumbnailUrl[0],
                        height: 120.0,
                        width: 130.0,
                        fit: BoxFit.fill,
                      ),
                    ):CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  width: 170.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.model.shortInfo,
                        style: TextStyle(fontSize: 11.0, color: Colors.black45),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'MRP: ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            '${widget.model.mrp}',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            '${widget.model.price}',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Discount: ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            '${widget.model.discount}',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Quantity: ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            '${widget.model.quantity}',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteAlreadyExistImageDialog(context);
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('EDIT PRODUCT'),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                        child: IconButton(
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (_) =>
                                    UploadPage(model: widget.model));
                            Navigator.push(context, route);
                          },
                          splashRadius: 30.0,
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
