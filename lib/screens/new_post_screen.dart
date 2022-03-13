import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import '../models/post_dto.dart';
import '../widgets/semantics.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPost';

  const NewPostScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var newPost = PostDTO();
  LocationData? locationData;
  var locationService = Location();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
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
    locationData = await locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    File imageFile = ModalRoute.of(context)!.settings.arguments as File;
    if (imageFile.path != '') {
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
              SizedBox(height: 200, width: 200, child: Image.file(imageFile)),
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
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

/*
* Upload the data into the firestore database using a data transfer object
*/
  void uploadData(String value, File imageFile) async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    newPost.imageUrl = await storageReference.getDownloadURL();
    newPost.createDate = DateTime.now();
    newPost.latitude = locationData?.latitude;
    newPost.longitude = locationData?.longitude;
    newPost.quantity = int.parse(value);
    newPost.addDatabase();
  }
}
