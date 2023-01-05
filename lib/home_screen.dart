import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcda8),
        title: const Text(
          'home',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const Center(child: Text('home', style: TextStyle(fontSize: 32.0))),
    );
  }
}
