import 'package:flutter/material.dart';
import '../models/post.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detailView';

  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(post.imageUrl)],
        ));
  }
}
