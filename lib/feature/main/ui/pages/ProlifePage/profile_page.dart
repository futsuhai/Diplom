import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../app/ui/app_loader.dart';
import '../../../../../app/ui/components/app_snackBar.dart';
import '../../../../../app/ui/components/app_text_field.dart';
import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../auth/domain/entities/user_entity/user_entity.dart';
import '../../../../posts/domain/entity/post/ui/post_list.dart';
import '../../components/app_post_field.dart';
import 'components/app_text_field_profile.dart';
import 'components/postFieldProfile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
          state.whenOrNull(authorized: (userEntity) {
            if (userEntity.userState?.hasData == true) {
              AppSnackBar.showSnackBarWithMessage(
                  context, userEntity.userState?.data);
            }
            if (userEntity.userState?.hasError == true) {
              AppSnackBar.showSnackBarWithError(context,
                  ErrorEntity.fromException(userEntity.userState?.error));
            }
          });
        }, builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity,
          );
          if (userEntity?.userState?.connectionState ==
              ConnectionState.waiting) {
            return const AppLoader();
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.6,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/assets/post1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          right: 5,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings),
                                iconSize: 34.0,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 130,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => _DataProfileUpdate(
                                      userEntity: userEntity!));
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(userEntity?.image ??
                                        "https://firebasestorage.googleapis.com/v0/b/url-image-storage.appspot.com/o/image.jpg?alt=media&token=cc507dc3-982b-437a-8720-d09b31ab7fc7"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -70,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(35, 34, 32, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  userEntity?.username ?? "null",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  userEntity?.description ?? "null",
                                  style: const TextStyle(
                                    color: Color.fromRGBO(140, 140, 139, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: Color.fromRGBO(35, 34, 32, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16),
                    child: PostFieldProfile(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PostList(userEntity: userEntity!),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

// User Avatar update
class _AvatarProfileUpdate extends StatefulWidget {
  final UserEntity userEntity;

  const _AvatarProfileUpdate({Key? key, required this.userEntity})
      : super(key: key);

  @override
  State<_AvatarProfileUpdate> createState() => _AvatarProfileUpdateState();
}

class _AvatarProfileUpdateState extends State<_AvatarProfileUpdate> {
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

// User profile update
class _DataProfileUpdate extends StatefulWidget {
  final UserEntity userEntity;

  const _DataProfileUpdate({Key? key, required this.userEntity})
      : super(key: key);

  @override
  State<_DataProfileUpdate> createState() => _DataProfileUpdateState();
}

class _DataProfileUpdateState extends State<_DataProfileUpdate> {
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
    final TaskSnapshot task = await ref.putFile(_imageFile!);
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
                        String url = await _uploadImageToDatabase();
                        Navigator.pop(context);
                        context.read<AuthCubit>().userUpdate(image: url);
                        context.read<AuthCubit>().userUpdate(
                              username: usernameController.text,
                              description: descriptionController.text,
                            );
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
