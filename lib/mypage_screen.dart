import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcda8),
        title: const Text(
          'mypage',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:
          const Center(child: Text('mypage', style: TextStyle(fontSize: 32.0))),
    );
  }
}
