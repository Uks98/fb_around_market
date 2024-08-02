import 'package:fb_around_market/presentation/view/chat/s_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:ionicons/ionicons.dart';

import '../../../common/color/color_box.dart';
import '../map/s_all_place_map.dart';
import '../map/s_map_main_add_page.dart';
import '../my_page/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedItemPosition,
        children:   [
          const AllPlaceMapPage(),
          const UserMarkerSelectPage(),
           ChatPage(),
          const MyPage()
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        padding: const EdgeInsets.all(5),

        snakeViewColor: baseColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],

        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Ionicons.map_outline,size: 25,)),
          BottomNavigationBarItem(icon: Icon(Ionicons.pencil_outline,size: 25,)),
          BottomNavigationBarItem(icon: Icon(Ionicons.chatbox_outline), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Ionicons.person_outline,size: 25,)),
        ],
      ),
    );
  }
}
