import 'package:client_id/feature/main/ui/pages/account_screen.dart';
import 'package:client_id/feature/main/ui/pages/friends_screen.dart';
import 'package:client_id/feature/main/ui/pages/user_home_screen.dart';
import 'package:flutter/material.dart';

import '../../auth/domain/entities/user_entity/user_entity.dart';

class HomePage extends StatefulWidget {
  final UserEntity userEntity;

  const HomePage({Key? key, required this.userEntity}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(userEntity);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final UserEntity userEntity;
  List<Widget> _children = [];

  _HomePageState(this.userEntity) {
    _children = [
      UserHomeScreen(userEntity: userEntity),
      FriendsScreen(userEntity: userEntity),
      AccountScreen(userEntity: userEntity),
    ];
  } // create constructor

  void _navigatorBottomNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigatorBottomNavBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility), label: "friends"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "account"),
        ],
      ),
    );
  }
}
