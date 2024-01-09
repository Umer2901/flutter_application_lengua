import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_lengua/ui/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _taglineController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('Select an image')
                : Image.file(
                    _image!,
                    height: 100,
                  ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _taglineController,
              decoration: InputDecoration(labelText: 'Tagline'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveData,
              child: Text('Save Data'),
            ),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        String uid = user.uid;

        // Check if a document with the user's UID already exists
        var userDoc = await _firestore.collection('users').doc(uid).get();

        if (!userDoc.exists) {
          // Document does not exist, create a new one
          String imagePath = 'images/$uid/${DateTime.now()}.png';
          await _storage.ref(imagePath).putFile(_image!);
          String imageUrl = await _storage.ref(imagePath).getDownloadURL();

          await _firestore.collection('users').doc(uid).set({
            'uid': uid,
            'name': _nameController.text,
            'tagline': _taglineController.text,
            'image': imageUrl,
          });
        }

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Homepage(),
        ));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data. Please try again!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
