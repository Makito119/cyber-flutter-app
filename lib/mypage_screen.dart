import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key, required this.user});
  final Map<String, dynamic>? user;

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late Map<String, dynamic>? user;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //ユーザの名前を表示
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Text('自分', style: const TextStyle(fontSize: 25.0)),
          ),
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('名前:${user!["name"]}',
                            style: const TextStyle(fontSize: 25.0)),
                        Text('身分:${user!["identity"]}',
                            style: const TextStyle(fontSize: 25.0)),
                        Text('メール:${user!["email"]}',
                            style: const TextStyle(fontSize: 25.0))
                      ]),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () async {},
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffff9a7e),
                  borderRadius: BorderRadius.circular(130),
                ),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Center(
                  child: Text(
                    'ペアリング申請',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () async {},
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffff9a7e),
                  borderRadius: BorderRadius.circular(130),
                ),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Center(
                  child: Text(
                    'ペアリング承認',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
