import 'package:cyber_kaji_app/home_screen.dart';
import 'package:cyber_kaji_app/record_screen.dart';
import 'package:cyber_kaji_app/mypage_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final _screens = [
    const HomeScreen(),
    RecordPage(),
    const MyPageScreen(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xffff9a7e),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35), label: 'ホーム'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_outlined, size: 35), label: '記録'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined, size: 35), label: 'マイページ'),
        ],
        type: BottomNavigationBarType.fixed,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
