import 'dart:developer';
import 'dart:io';

import 'package:admin_panel/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class BannerImage extends StatefulWidget {
  BannerImage({Key key, this.model}) : super(key: key);
  ItemModel model;
  @override
  _BannerImageState createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  List thumbnailUrl = [0];

  bool isLoading = true;
  void initState() {
    FirebaseFirestore.instance
        .collection('sliderImage')
        .doc('bannerImage')
        .get()
        .then((value) {
      //print(value.data()['bannerImage']);
      thumbnailUrl = value.data()['bannerImage'];
      if (thumbnailUrl == null) thumbnailUrl = [];

      log(thumbnailUrl.toString());
    }).then((value) => setState(() {
              isLoading = false;
            }));
    super.initState();
  }

  Future<String> uploadImages(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('imageBanner')
        .child("${DateTime.now().millisecondsSinceEpoch.toString()}.png");
    final UploadTask uploadTask = ref.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }

  _deleteAlreadyExistImageDialog(int index, BuildContext context) {
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
        String url = thumbnailUrl[index];
        thumbnailUrl.removeAt(index);

        FirebaseStorage.instance.refFromURL(url).delete();
        FirebaseFirestore.instance
            .collection('sliderImage')
            .doc('bannerImage')
            .update({'bannerImage': thumbnailUrl}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Deleted Banner Successfully"),
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
          child: Text(
            'Delete Banner',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          height: 50,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Banners',
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
          actions: [
            IconButton(
                icon: Icon(Icons.add_a_photo_outlined),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: [
                        'jpg',
                        'jpeg',
                        'png',
                        'gif',
                      ]);

                  if (result == null) {
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }

                  File file = File(result.files.single.path);

                  var downloadUrl = await uploadImages(file);
                  log(downloadUrl);

                  if (downloadUrl != null) thumbnailUrl.add(downloadUrl);

                  print(thumbnailUrl);

                  await FirebaseFirestore.instance
                      .collection('sliderImage')
                      .doc('bannerImage')
                      .update({'bannerImage': thumbnailUrl}).then((value) {
                    log('imageBanner updated');
                    setState(() {
                      isLoading = false;
                    });
                  });
                })
          ],
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            child: (isLoading)
                ? CircularProgressIndicator()
                : thumbnailUrl.length == 0
                    ? Text('No Banner Availabe')
                    : ListView.builder(
                        itemCount: thumbnailUrl.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      thumbnailUrl[index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                      top: 50,
                                      bottom: 50,
                                      right: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(.5),
                                        ),
                                        child: Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_circle_up,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (index != 0) {
                                                  var temp =
                                                      thumbnailUrl[index];
                                                  thumbnailUrl[index] =
                                                      thumbnailUrl[(index - 1)];
                                                  thumbnailUrl[(index - 1)] =
                                                      temp;

                                                  FirebaseFirestore.instance
                                                      .collection('sliderImage')
                                                      .doc('bannerImage')
                                                      .update({
                                                    'bannerImage': thumbnailUrl
                                                  });
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_circle_down,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                if (index !=
                                                    thumbnailUrl.length - 1) {
                                                  var temp =
                                                      thumbnailUrl[index];
                                                  thumbnailUrl[index] =
                                                      thumbnailUrl[(index + 1)];
                                                  thumbnailUrl[(index + 1)] =
                                                      temp;

                                                  FirebaseFirestore.instance
                                                      .collection('sliderImage')
                                                      .doc('bannerImage')
                                                      .update({
                                                    'bannerImage': thumbnailUrl
                                                  });
                                                  setState(() {});
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                  Positioned(
                                      left: 10,
                                      top: 20,
                                      bottom: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(.3),
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _deleteAlreadyExistImageDialog(
                                                index, context);
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
          ),
        ));
  }
}
