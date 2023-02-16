import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  List thumbnailUrl;
  String longDescription;
  String details;
  String status;
  int price;
  int quantity;
  String category;
  int noOfProduct;
  int mrp;
  int discount;
  String pid;
  bool isFeatured;

  ItemModel({
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.isFeatured,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    quantity = int.parse(json['quantity']);
    pid = json['pid'];
    category = json['category'];
    mrp = json['mrp'];
    discount = json['discount'];
    details = json['details'];
    isFeatured = json['isFeatured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['details'] = this.details;
    data['isFeatured'] = this.isFeatured;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
