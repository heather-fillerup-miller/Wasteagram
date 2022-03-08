import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/detail_screen.dart';
import 'package:wasteagram/screens/new_post_screen.dart';
import '../models/post.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/';

  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  File? image;
  final picker = ImagePicker();
  String? url;

/*
* Pick an image from the gallery, upload it to Firebase Storage and return 
* the URL of the image in Firebase Storage.
*/
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);

    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    url = await storageReference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Wastegram Posts')),
      body: StreamBuilder(
        //order items by date, listing newest at the top
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createDate', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var post =
                            Post.fromDatabase(snapshot.data!.docs[index]);
                        return ListTile(
                            leading: SizedBox(
                              height: 100.00,
                              width: 100.0,
                              child: Image.network(post.imageUrl),
                            ),
                            title:
                                Text(DateFormat.yMd().format(post.createDate)),
                            subtitle: Text(post.quantity.toString()),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, DetailScreen.routeName,
                                  arguments: post);
                            } //NAVIGATE TO DETAILS using index
                            );
                      }),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            getImage();
            Navigator.pushNamed(context, NewPostScreen.routeName,
                arguments: image);
          },
          child: const Icon(Icons.add_a_photo)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
