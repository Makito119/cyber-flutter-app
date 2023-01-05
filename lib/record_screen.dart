import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordPage extends StatefulWidget {
  // 状態を持ちたいので StatefulWidget を継承
  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  late Timer _timer; // この辺が状態
  late DateTime _time;
  final myController = TextEditingController();
  @override
  // void initState() {
  //   // 初期化処理
  //   _time = DateTime.utc(0, 0, 0);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcda8),
        title: const Text(
          '記録画面',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  //controller: myController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: '日付',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (text) {
                    // TODO: ここで取得したtextを使う
                    name = text;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  //controller: myController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'お仕事',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (text) {
                    // TODO: ここで取得したtextを使う
                    name = text;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: Text('タイマー・手動'),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 28.0, bottom: 28.0),
              //   child: Clock(),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ElevatedButton(
                      child: const Text(
                        '開始',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ElevatedButton(
                      child: const Text(
                        'ストップ',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  child: Text('記録する'),
                  onPressed: () {
                    // TODO: 新規登録
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Clock extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ClockState();
//   }
// }

// class _ClockState extends State<Clock> {
//   String _time = '';

//   @override
//   void initState() {
//     Timer.periodic(
//       Duration(seconds: 1),
//       _onTimer,
//     );
//     super.initState();
//   }

//   void _onTimer(Timer timer) {
//     var now = DateTime.now();
//     var formatter = DateFormat('HH:mm:ss');
//     var formattedTime = formatter.format(now);
//     setState(() => _time = formattedTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       _time,
//       style: TextStyle(
//         fontSize: 60.0,
//         fontFamily: 'IBMPlexMono',
//       ),
//     );
//   }
// }
