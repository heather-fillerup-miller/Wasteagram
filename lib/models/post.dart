import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int quantity;
  final DateTime createDate;

  Post(
      {required this.imageUrl,
      required this.latitude,
      required this.longitude,
      required this.quantity,
      required this.createDate});

  factory Post.fromDatabase(DocumentSnapshot post) {
    return Post(
        imageUrl: post['imageUrl'],
        latitude: post['latitude'].toDouble() ?? 0,
        longitude: post['longitude'].toDouble() ?? 0,
        quantity: post['quantity'].toInt(),
        createDate: post['createDate'].toDate());
  }
}
