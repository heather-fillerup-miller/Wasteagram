import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/wasteagram_post_details.dart';

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
    final geolocation =
        '( ' + post.getLatitude + ' , ' + post.getLongitude + ' )';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasteagram Post'),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            //on back go to List Screen
            onPressed: () => Navigator.pop(context)),
      ),
      body: Card(child: wasteagramPostDetails(context, post, geolocation)),
    );
  }
}
