import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.user});
  final Map<String, dynamic>? user;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Map<String, dynamic>? user;
  String pairingId = "";
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcda8),
        title: const Text(
          "My page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //ユーザの名前を表示
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Text('自分', style: const TextStyle(fontSize: 25.0)),
            ),
            
            
          ],
        ),
      ),
    );
  }
}
