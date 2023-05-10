import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'app_text_field_profile.dart';

class DataProfileUpdate extends StatefulWidget {
  final UserEntity userEntity;

  const DataProfileUpdate({Key? key, required this.userEntity})
      : super(key: key);

  @override
  State<DataProfileUpdate> createState() => _DataProfileUpdateState();
}

class _DataProfileUpdateState extends State<DataProfileUpdate> {
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
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
    await ref.putFile(_imageFile!);
    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
    // do request to db
  }

  @override
  void dispose() {
    usernameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // TODO description
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 540,
          width: 600,
          child: Container(
            color: const Color.fromRGBO(14, 14, 14, 1),
            child: Column(
              children: [
                // User profile update
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Profile",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: _getImage,
                  child: ClipOval(
                    child: SizedBox(
                      width: 130,
                      height: 130,
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
                const SizedBox(height: 40),
                const Text(
                  "Username",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                  child: AppTextFieldProfile(
                      controller: usernameController,
                      labelText: widget.userEntity.username),
                ),
                const SizedBox(height: 20),
                const Text(
                  "About",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                  child: AppTextFieldProfile(
                      controller: descriptionController,
                      labelText: widget.userEntity.description),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        if(_imageFile != null) {
                          String url = await _uploadImageToDatabase();
                          Navigator.pop(context);
                          context.read<AuthCubit>().userUpdate(
                            image: url,
                            username: usernameController.text,
                            description: descriptionController.text,
                          );
                        }else{
                          Navigator.pop(context);
                          context.read<AuthCubit>().userUpdate(
                            image: widget.userEntity.image,
                            username: usernameController.text,
                            description: descriptionController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Color.fromRGBO(35, 34, 32, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
                // User password update
              ],
            ),
          ),
        )
      ],
    );
  }
}