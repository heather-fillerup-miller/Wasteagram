import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  String get getShortDate => DateFormat.yMd().format(createDate);
  String get getLongDate => DateFormat.yMMMMd('en_US').format(createDate);
  String get getLatitude => latitude.toString();
  String get getLongitude => longitude.toString();
  String get getQuantity => quantity.toString();

  factory Post.fromDatabase(DocumentSnapshot post) {
    return Post(
        imageUrl: post['imageUrl'],
        latitude: post['latitude'].toDouble() ?? 0,
        longitude: post['longitude'].toDouble() ?? 0,
        quantity: (post['quantity']),
        createDate: post['createDate'].toDate());
  }
}
