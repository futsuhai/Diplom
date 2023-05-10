// User Avatar update
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';

class AvatarProfileUpdate extends StatefulWidget {
  final UserEntity userEntity;

  const AvatarProfileUpdate({Key? key, required this.userEntity})
      : super(key: key);

  @override
  State<AvatarProfileUpdate> createState() => _AvatarProfileUpdateState();
}

class _AvatarProfileUpdateState extends State<AvatarProfileUpdate> {
  final picker = ImagePicker();
  File? _imageFile;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<String> _uploadImageToDatabase() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref =
    storage.ref().child('${_imageFile?.path.split('/').last}');
    final TaskSnapshot task = await ref.putFile(_imageFile!);
    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
    // do request to db
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ElevatedButton(
          onPressed: _getImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text('Choose Image'),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: ClipOval(
            child: SizedBox(
              width: 150,
              height: 150,
              child: _imageFile != null
                  ? Image.file(
                File(_imageFile!.path),
                fit: BoxFit.cover,
              ) // edit to previous user avatar
                  : Image.network(
                widget.userEntity.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            String url = await _uploadImageToDatabase();
            Navigator.pop(context);
            context.read<AuthCubit>().userUpdate(image: url);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text('Upload Image'),
        ),
      ],
    );
  }
}