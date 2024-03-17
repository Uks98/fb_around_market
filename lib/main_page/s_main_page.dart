import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/logic/map/all_place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:ionicons/ionicons.dart';

import '../logic/map/map_main_add_page.dart';
import '../my_page/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  int _selectedItemPosition = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedItemPosition,
        children:  [
          AllPlaceMapPage(),
          UserMarkerSelectPage(),
           MyPage()
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        padding: const EdgeInsets.all(5),

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: baseColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],

        ///configuration for SnakeNavigationBar.gradient
        //snakeViewGradient: selectedGradient,
        //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        //unselectedItemGradient: unselectedGradient,

        // showUnselectedLabels: showUnselectedLabels,
        // showSelectedLabels: showSelectedLabels,

        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Ionicons.map_outline,size: 25,)),
          BottomNavigationBarItem(icon: Icon(Ionicons.pencil_outline,size: 25,)),
          BottomNavigationBarItem(icon: Icon(Ionicons.person_outline,size: 25,)),
          //BottomNavigationBarItem(icon: Icon(CustomIcons.home), label: 'home'),
        ],
      ),
    );
  }
}
