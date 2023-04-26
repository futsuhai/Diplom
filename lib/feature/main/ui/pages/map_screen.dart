import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/image_from_url.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final picker = ImagePicker();
  File? _imageFile;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImageToFirebase() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('image.jpg');
    final TaskSnapshot task = await ref.putFile(_imageFile!);
    final String downloadUrl = await ref.getDownloadURL();
    print('File Uploaded: $downloadUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Colors.grey[600],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _getImage,
            child: Text('Choose Image'),
          ),
          SizedBox(height: 16),
          _imageFile != null ? Image.file(File(_imageFile!.path), height: 300) : SizedBox(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _uploadImageToFirebase,
            child: Text('Upload Image'),
          ),

        ],
      ),
    );
  }
}
