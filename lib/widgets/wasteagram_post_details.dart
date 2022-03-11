import 'package:flutter/material.dart';
import '../models/post.dart';

Widget wasteagramPostDetails(
    BuildContext context, Post post, String geolocation) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          post.getLongDate,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      SizedBox(height: 300, width: 300, child: Image.network(post.imageUrl)),
      ListTile(
        title: Center(
            child: Text(
          'Quantity: ' + post.getQuantity,
          style: Theme.of(context).textTheme.headline5,
        )),
        subtitle: Center(child: Text('Location: ' + geolocation)),
      )
    ],
  );
}
