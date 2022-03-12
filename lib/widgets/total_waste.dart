import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

Widget getTotalWaste(List<QueryDocumentSnapshot> documentSnapshot) {
  int totalWaste = 0;
  //print('Snapshot: ${Post.fromDatabase(snapshot.data!.docs[0]).quantity}');
  for (var document in documentSnapshot) {
    totalWaste += Post.fromDatabase(document).quantity;
  }
  return Text(totalWaste.toString());
}
