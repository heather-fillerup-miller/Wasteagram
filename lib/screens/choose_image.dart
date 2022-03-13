import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/new_post_screen.dart';

class ChooseImage extends StatefulWidget {
  static const routeName = '/chooseImage';

  const ChooseImage({Key? key}) : super(key: key);

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  File? imageFile;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Choose option'),
              content: SingleChildScrollView(
                  child: ListBody(
                children: [
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text('Gallery'),
                    leading: Icon(Icons.account_box_outlined),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text('Camera'),
                    leading: Icon(Icons.camera),
                  )
                ],
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Image'),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            //on back go to List Screen
            onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
                child: (imageFile == null)
                    ? Text('Choose Image')
                    : CircularProgressIndicator()),
            MaterialButton(
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: Text('Select Image'),
            )
          ],
        ),
      )),
    );
  }

  /*
* Pick an image from the gallery return 
* the image as a file
*/
  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.pushNamed(context, NewPostScreen.routeName, arguments: imageFile);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.pushNamed(context, NewPostScreen.routeName, arguments: imageFile);
  }
}
