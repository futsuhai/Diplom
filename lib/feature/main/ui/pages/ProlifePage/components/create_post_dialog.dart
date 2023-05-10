import 'dart:io';

import 'package:client_id/feature/posts/domain/state/post_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'app_text_field_profile.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final contentController = TextEditingController();

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
      contentPadding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 460,
          width: 640,
          child: Container(
            color: const Color.fromRGBO(14, 14, 14, 1),
            child: Column(
              children: [
                // User profile update
                 Row(
                   children: [
                     Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.userEntity.username,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                ),
                     //add image
                     IconButton(
                       onPressed: () {
                         _getImage();
                       },
                       iconSize: 28,
                       icon: const Icon(Icons.image),
                       padding: const EdgeInsets.only(left: 160),
                       color: const Color.fromRGBO(140, 140, 139, 1),
                     ),
                     // post
                     IconButton(
                       onPressed: () async {
                         // add post method
                         String url = await _uploadImageToDatabase();
                         Navigator.pop(context);
                         context.read<PostCubit>().createPost(
                           content: contentController.text,
                           image: url
                         );
                       },
                       iconSize: 28,
                       icon: const Icon(Icons.arrow_upward),
                       padding: const EdgeInsets.only(left: 0),
                       color: const Color.fromRGBO(140, 140, 139, 1),
                     ),
                   ],
                 ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                  child: AppTextFieldProfile(
                      controller: contentController,
                      labelText: "What's new with you?"),
                ),
                const SizedBox(height: 8),
                //preload image
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8, top: 6),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return _imageFile != null ? SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth * (3 / 4), // aspect ratio of 4:3
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.file(
                            File(_imageFile!.path),
                          ),
                        ),
                      ) : const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
