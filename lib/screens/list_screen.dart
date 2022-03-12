import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/screens/new_post_screen.dart';
import '../models/post.dart';
import '../widgets/total_waste.dart';
import '../widgets/wasteagram_post_tile.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/';

  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int totalWaste = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //order items by date, listing newest at the top
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createDate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(getTotalWaste(snapshot.data!.docs) + ' - Wastegram'),
              leadingWidth: 100,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var post =
                            Post.fromDatabase(snapshot.data!.docs[index]);
                        totalWaste += post.quantity;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: wastegramPost(context, post),
                        );
                      }),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, NewPostScreen.routeName);
                },
                child: const Icon(Icons.add_a_photo)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Wastegram'),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(child: CircularProgressIndicator()),
                ]),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, NewPostScreen.routeName);
                },
                child: const Icon(Icons.add_a_photo)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
      },
    );
  }

  String getTotalWaste(List<QueryDocumentSnapshot> documentSnapshot) {
    int totalWaste = 0;
    //print('Snapshot: ${Post.fromDatabase(snapshot.data!.docs[0]).quantity}');
    for (var document in documentSnapshot) {
      totalWaste += Post.fromDatabase(document).quantity;
    }
    return totalWaste.toString();
  }
}
