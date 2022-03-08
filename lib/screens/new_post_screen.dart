import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import '../models/post_dto.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPost';

  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  LocationData? locationData;
  var locationService = Location();

  final formKey = new GlobalKey<FormState>();
  final post = PostDTO();

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
      locationData = null;
    }
    locationData = await locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('New Post'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center());
  }

  void uploadData() async {
    //post.imageUrl = url;
    post.createDate = DateTime.now();
    post.latitude = locationData?.longitude;
    post.longitude = locationData?.latitude;
    post.addDatabase();

    setState(() {});
  }
}
