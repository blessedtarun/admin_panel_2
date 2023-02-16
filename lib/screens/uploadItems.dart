//import 'dart:html';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:admin_panel/Config/config.dart';
import 'package:admin_panel/model/item.dart';
import 'package:admin_panel/screens/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:e_shop/Admin/adminShiftOrders.dart';
// import 'package:e_shop/Config/config.dart';
// import 'package:e_shop/Widgets/loadingWidget.dart';
// import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:admin_panel/widgets/customAddTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  ItemModel model;
  UploadPage({this.model});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  // Option 2
  String _selectedCategory;

  bool get wantKeepAlive => true;
  List<File> file;
  List<Image> images = [];
  PickedFile imageFile;
  bool _isEditing = false;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _detailsTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _quantityOfProduct = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController _mrpTextEditingController = TextEditingController();

  bool uploading = false;
  bool isFeatured = true;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.model != null) {
      isFeatured = widget.model.isFeatured;
      _selectedCategory = widget.model.category;
      _isEditing = true;
      _descriptionTextEditingController.text = widget.model.longDescription;
      _detailsTextEditingController.text = widget.model.details;
      _titleTextEditingController.text = widget.model.title;
      _priceTextEditingController.text = widget.model.price.toString();
      _mrpTextEditingController.text = widget.model.mrp.toString();
      _quantityOfProduct.text = widget.model.quantity.toString();
      _shortInfoTextEditingController.text = widget.model.shortInfo;
    } else {
      // widget.model.thumbnailUrl = [];
    }

    if (_isEditing)
      widget.model.thumbnailUrl.forEach((element) {
        images.add(Image.network(
          element,
          fit: BoxFit.fill,
        ));
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isEditing)
      images.forEach((element) {
        precacheImage(element.image, context);
      });
  }

  @override
  Widget build(BuildContext context) {
    return displayAdminHomeScreen();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  _deleteAlreadyExistImageDialog(int index, Image image, BuildContext context) {
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
        String url = widget.model.thumbnailUrl[index];
        widget.model.thumbnailUrl.removeAt(index);
        images.removeAt(index);
        firebase_storage.FirebaseStorage.instance.refFromURL(url).delete();
        FirebaseFirestore.instance
            .collection('products')
            .doc(widget.model.pid)
            .update({'thumbnailUrl': widget.model.thumbnailUrl}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Deleted Image Successfully"),
          ));
          Navigator.pop(context);
          setState(() {});
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Container(
          child: image,
          height: 50,
          width: 60,
        ),
      ),
      content: Text("Would you like to delete the following image?"),
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  displayAdminHomeScreen() {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0.0,
      //   child: Icon(Icons.arrow_back),
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Product Details',
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
      body: uploading
          ? Center(child: CircularProgressIndicator())
          : getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
            Colors.blue.withOpacity(.1),
            Colors.pink.withOpacity(.1)
          ])),
      padding: EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
            ),
            /*click to add image btn*/
            (_isEditing)
                ? Text(
                    'Already uploaded Images',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(
              height: 5,
            ),
            widget.model == null
                ? Container(
                    height: 1,
                    width: 1,
                  )
                : Container(
                    height: 150,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          color: Colors.grey[300])
                    ]),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.model.thumbnailUrl.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onLongPress: () {
                                  _deleteAlreadyExistImageDialog(
                                      index, images[index], context);
                                },
                                child: Container(
                                    height: 135,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: images[index],
                                      // child: Image.network(
                                      //   widget.model.thumbnailUrl[index],
                                      //   fit: BoxFit.fill,
                                      // ),
                                    )),
                              ),
                            ),
                          );
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Images that going to be added',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            file == null
                ? Container(
                    alignment: Alignment.center,
                    height: 150,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          color: Colors.grey[300])
                    ]),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'No Images Selected to add For this Product',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 156,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          color: Colors.grey[300])
                    ]),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: file.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  height: 135,
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      file[index],
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ),
                          );
                        }),
                  ),
            ElevatedButton(
                onPressed: () => takeImage(context), child: Text('Add Images')),
            SizedBox(
              height: 10.0,
            ),
            CustomAddProduct(
              hintname: 'Product Name',
              label: 'Product Name',
              colors: Colors.grey,
              txtController: _titleTextEditingController,
            ),
            CustomAddProduct(
              hintname: 'MRP',
              label: 'MRP',
              txtController: _mrpTextEditingController,
            ),
            CustomAddProduct(
              hintname: 'Prduct Price',
              label: 'Prduct Price',
              txtController: _priceTextEditingController,
            ),
            CustomAddProduct(
              hintname: 'Product Quantity',
              label: 'Product Quantity',
              txtController: _quantityOfProduct,
            ),
            CustomAddProduct(
              hintname: 'Short Description',
              label: 'Short Description',
              txtController: _shortInfoTextEditingController,
            ),
            Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: DropdownButton<String>(
                  hint: Text("Select Category      "),
                  value: _selectedCategory,
                  items: EcommerceApp.category.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (values) {
                    setState(() {
                      _selectedCategory = values;
                    });
                    print(values);
                  },
                )),
            RadioListTile(
                value: true,
                groupValue: isFeatured,
                title: Text('Featured Product'),
                onChanged: (newvalue) {
                  setState(() {
                    isFeatured = newvalue;
                    log(isFeatured.toString());
                  });
                }),
            RadioListTile(
                value: false,
                groupValue: isFeatured,
                title: Text('Not Featured Product'),
                onChanged: (newvalue) {
                  setState(() {
                    isFeatured = newvalue;
                    log(isFeatured.toString());
                  });
                }),

            /*long description*/
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              margin: EdgeInsets.all(5.0),
              child: TextField(
                textAlign: TextAlign.start,
                controller: _descriptionTextEditingController,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Long Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  // focusedBorder: InputBorder.none,
                  hintText: 'Long Description',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              margin: EdgeInsets.all(5.0),
              child: TextField(
                textAlign: TextAlign.start,
                maxLines: 4,
                controller: _detailsTextEditingController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  // focusedBorder: InputBorder.none,
                  hintText: 'Details',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                ),
                
                child: _isEditing
                    ? Text(
                        "Save Product Info",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Add New Product",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                onPressed: () {
                  if (_shortInfoTextEditingController.text.isEmpty ||
                      _titleTextEditingController.text.isEmpty ||
                      _descriptionTextEditingController.text.isEmpty ||
                      _quantityOfProduct.text.isEmpty ||
                      _priceTextEditingController.text.isEmpty ||
                      _selectedCategory == null ||
                      _mrpTextEditingController.text.isEmpty ||
                      _detailsTextEditingController.text.isEmpty) {
                  } else if (!_isEditing && file == null) {
                    Fluttertoast.showToast(
                        msg: "Please Add minimum 1 Images",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else
                    _isEditing ? editProduct() : uploadImageAndSaveItemInfo();
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Add Product Image",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              // SimpleDialogOption(
              //   child: Text(
              //     "Click a Photo",
              //     style: TextStyle(color: Colors.deepOrange),
              //   ),
              //   onPressed: capturePhotoWithCamera,
              // ),
              SimpleDialogOption(
                child: Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: pickPhotoFromGallery,
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

  // capturePhotoWithCamera() async {
  //   Navigator.pop(context);
  //   // ignore: deprecated_member_use
  //   File imageFile = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

  //   setState(() {
  //     file = imageFile;
  //   });
  // }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'gif',
        ]);
    if (result != null) {
      if (file == null) file = [];
      file += result.paths.map((e) => File(e)).toList();
      setState(() {});
    }
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _quantityOfProduct.clear();
      _selectedCategory = null;
      _mrpTextEditingController.clear();
      isFeatured = true;
    });
  }

  List<String> imageDownloadUrlList;
  List<String> tempURL = [];
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////upload multiple images
  Future<List<String>> uploadImages(List<File> images) async {
    if (images.length < 1) return null;

    List<String> _downloadUrls = [];

    await Future.forEach(images, (image) async {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('products')
          .child(widget.model == null ? productId : widget.model.pid)
          .child("product_$productId${image.path}.png");
      final UploadTask uploadTask = ref.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final url = await taskSnapshot.ref.getDownloadURL();
      _downloadUrls.add(url);
      if (widget.model != null)
        widget.model.thumbnailUrl.add(url);
      else
        tempURL.add(url);
    });
    log('in uploadImages');
    return _downloadUrls;
  }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    if (file != null) await uploadImages(file);
    await saveItemInfo();
  }

  Future<String> uploadItemImage(mFileImage, String index) async {
    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("products")
        .child("product_$productId$index.png");
    String downloadURL;

    UploadTask uploadTask = storageReference.putFile(mFileImage);
    log('in upload');

    downloadURL = await (await uploadTask).ref.getDownloadURL();
    if (widget.model != null)
      widget.model.thumbnailUrl.add(downloadURL);
    else
      // tempURL = downloadURL;
      log(downloadURL);
    // setState(() {
    //   uploading = false;
    // });

    return downloadURL;
  }

  Future saveItemInfo() async {
    log('in saveItem');
    //log(widget.model.thumbnailUrl.toString() ?? []);

    int discount = 0;
    int mrp = int.parse(_mrpTextEditingController.text);
    int price = int.parse(_priceTextEditingController.text);
    discount = (((mrp - price) / mrp) * 100).round();
    final itemsRef = FirebaseFirestore.instance.collection("products");
    await itemsRef.doc(productId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": (widget.model != null)
          ? widget.model.thumbnailUrl
          : tempURL != null
              ? tempURL
              : [],
      "category": _selectedCategory,
      "quantity": _quantityOfProduct.text,
      "title": _titleTextEditingController.text.trim(),
      "mrp": int.parse(_mrpTextEditingController.text),
      "discount": discount,
      "details": _detailsTextEditingController.text,
      "pid": productId,
      "isFeatured": isFeatured,
    });

    setState(() {
      file = null;
      isFeatured = true;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
      _detailsTextEditingController.clear();
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => ProductsPage()));
  }

  Future editProduct() async {
    setState(() {
      uploading = true;
    });
    if (file != null) {
      await uploadImages(file);
    }

    int discount = 0;
    int mrp = int.parse(_mrpTextEditingController.text);
    int price = int.parse(_priceTextEditingController.text);
    discount = (((mrp - price) / mrp) * 100).round();
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.model == null ? productId : widget.model.pid)
        .update({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "category": _selectedCategory,
      "quantity": _quantityOfProduct.text,
      "title": _titleTextEditingController.text.trim(),
      "mrp": int.parse(_mrpTextEditingController.text),
      "discount": discount,
      "details": _detailsTextEditingController.text,
      "isFeatured": isFeatured,
      "thumbnailUrl": (widget.model != null)
          ? widget.model.thumbnailUrl
          : tempURL != null
              ? tempURL
              : [],
    }).then((value) {
      setState(() {
        uploading = false;
      });
      Navigator.pop(context);
    }).catchError((error) => print("Failed to update user: $error"));
  }
}
