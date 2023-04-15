import 'dart:io';

import 'package:client_id/feature/main/ui/components/account_post_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user_entity/user_entity.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/icons/avatar_test.png'),
                        ),
                      ),
                    )
                    //  some numbers: post, followers
                  ],
                ),
              ),
            ),
            // Name and about
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      userEntity.username,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    "SUPER SUPER SUPER Mega Dark Market!!!",
                  ),
                ],
              ),
            ),
            //button edit profile
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 200,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Edit Profile")),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: TabBarView(
              children: [
                AccountPostSpace(),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
