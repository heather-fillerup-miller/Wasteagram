import 'package:cloud_firestore/cloud_firestore.dart';

class PostDTO {
  String? imageUrl;
  double? latitude;
  double? longitude;
  int? quantity;
  DateTime? createDate;

  PostDTO(
      {this.imageUrl,
      this.latitude,
      this.longitude,
      this.quantity,
      this.createDate});

  void addDatabase() {
    FirebaseFirestore.instance.collection('posts').add({
      'imageUrl': imageUrl,
      'createDate': createDate,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity
    });
  }
}
