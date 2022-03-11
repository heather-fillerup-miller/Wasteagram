import 'package:flutter/material.dart';

Widget semanticsImage(Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: "Image of Wasted Food",
    image: true,
  );
}

Widget semanticsLocation(Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: "Location of Wasted Food",
  );
}

Widget semanticsQuantityText(int quantity, Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: 'Quantity of Wasted Food is $quantity items',
  );
}

Widget semanticsQuantityInput(Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: 'Wasted Food Quantity',
    onTapHint: 'Enter the number of wasted food items',
    textField: true,
    focusable: true,
  );
}

Widget semanticsUploadPost(Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: 'Upload Wasteagram Post',
    onTapHint: 'Post Uploaded',
    button: true,
    enabled: true,
  );
}

Widget semantisSharePost({childWidget}) {
  return Semantics(
    child: childWidget,
    label: 'Share a New Wasteagram Post',
    button: true,
    onTapHint: 'Share a new Wasteagram Post',
  );
}

Widget semanticsWasteagramPostDetails(Widget childWidget) {
  return Semantics(
    child: childWidget,
    label: 'View Wastegram Post Details',
    onTapHint: 'View Wastegram Post Details',
    button: true,
    enabled: true,
  );
}
