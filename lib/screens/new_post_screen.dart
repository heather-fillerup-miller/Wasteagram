import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import '../models/post_dto.dart';
import '../widgets/semantics.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPost';

  const NewPostScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File imageFile = File('');
  var newPost = PostDTO();
  LocationData? locationData;
  var locationService = Location();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (imageFile.path == '') {
      return AlertDialog(
        title: const Text('Choose option'),
        content: SingleChildScrollView(
            child: ListBody(
          children: [
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                _openGallery(context);
              },
              title: const Text('Gallery'),
              leading: const Icon(Icons.account_box_outlined),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                _openCamera(context);
              },
              title: const Text('Camera'),
              leading: const Icon(Icons.camera),
            )
          ],
        )),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('New Wasteagram Post'),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () => Navigator.of(context).pop()),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    height: 200, width: 200, child: Image.file(imageFile)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: semanticsQuantityInput(TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Quantity: ",
                              border: OutlineInputBorder()),
                          onSaved: (value) {
                            if (value != null) {
                              uploadData(value, imageFile);
                            }
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !newPost.isValidQuantity(value)) {
                              return 'Enter a valid Quantity';
                            }
                            return null;
                          },
                        )))),
              ),
              ElevatedButton(
                  child: const Text('Upload'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Waste Posted!'),
                      ));
                      Navigator.pop(context);
                    }
                  }),
            ],
          ));
    }
  }

/*
* Pick an image from the gallery
*/
  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

/*
* Pick an image from the camera return 
*/
  void _openCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

/*
* Get Location
*/

  Future retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {}
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    return locationService.getLocation();
  }

/*
* Get Location and upload the data into the firestore database using a data transfer object
*/
  void uploadData(String value, File imageFile) async {
    LocationData geolocation = await retrieveLocation();
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    newPost.imageUrl = await storageReference.getDownloadURL();
    newPost.createDate = DateTime.now();
    newPost.latitude = geolocation.latitude;
    newPost.longitude = geolocation.longitude;
    newPost.quantity = int.parse(value);
    newPost.addDatabase();
  }
}
