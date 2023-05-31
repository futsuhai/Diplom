
import 'package:client_id/feature/main/ui/pages/DialogPage/chats_screen.dart';
import 'package:client_id/feature/main/ui/pages/FriendsPage/friends_screen.dart';
import 'package:client_id/feature/main/ui/pages/MapPage/map_screen.dart';
import 'package:client_id/feature/main/ui/pages/ProlifePage/profile_page.dart';
import 'package:client_id/feature/main/ui/pages/HomePage/user_home_screen.dart';
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
      UserHomeScreen(),
      DialogScreen(),
      const FriendsScreen(),
      ProfileScreen(),
      MapPage(),
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
        backgroundColor: const Color.fromRGBO(35, 34, 32, 1),
        currentIndex: _selectedIndex,
        onTap: _navigatorBottomNavBar,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey[200],
        selectedItemColor: Colors.teal.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Dialogs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}
