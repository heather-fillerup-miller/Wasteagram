import 'package:flutter/material.dart';
import './semantics.dart';
import '../screens/detail_screen.dart';
import '../models/post.dart';

Widget wastegramPost(BuildContext context, Post post) {
  return semanticsWasteagramPostDetails(
    ListTile(
        leading: semanticsImage(SizedBox(
          height: 100.00,
          width: 100.0,
          child: Image.network(post.imageUrl),
        )),
        title: semanticsQuantityText(
            post.quantity,
            Text(
              post.getShortDate,
              style: Theme.of(context).textTheme.headline6,
            )),
        trailing: Text(
          post.getQuantity,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: post);
        } //NAVIGATE TO DETAILS using index
        ),
  );
}
