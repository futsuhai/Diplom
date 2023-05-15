import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../app/ui/app_loader.dart';
import '../../../../../app/ui/components/app_snackBar.dart';
import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../auth/domain/entities/user_entity/user_entity.dart';
import '../../../../posts/domain/entity/post/ui/post_list_profile.dart';
import 'components/create_post_container.dart';
import 'components/setting_dialog.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        ),
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
                                onPressed: () async {
                                  showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => SettingDialog(
                                          userEntity: userEntity!));
                                },
                                icon: const Icon(Icons.settings),
                                iconSize: 34.0,
                                color: const Color.fromRGBO(130, 130, 129, 1),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 146,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {},
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
                          bottom: -30,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16),
                    child: CreatePostContainer(userEntity: userEntity!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PostListProfile(userEntity: userEntity),
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
