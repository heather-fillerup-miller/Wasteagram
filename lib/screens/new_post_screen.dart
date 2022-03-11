import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../models/post_dto.dart';
import '../widgets/semantics.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPost';

  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var newPost = PostDTO();
  final picker = ImagePicker();
  File imageFile = File('');
  LocationData? locationData;
  var locationService = Location();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getImage();
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
                              uploadData(value);
                            }
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                newPost.isValidQuantity(value)) {
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
* Pick an image from the gallery return 
* the image as a file
*/
  getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    setState(() {});
  }

/*
* Upload the data into the firestore database using a data transfer object
*/
  void uploadData(String value) async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    newPost.imageUrl = await storageReference.getDownloadURL();
    newPost.createDate = DateTime.now();
    newPost.latitude = locationData?.latitude;
    newPost.longitude = locationData?.latitude;
    newPost.quantity = int.parse(value);
    newPost.addDatabase();
  }
}
