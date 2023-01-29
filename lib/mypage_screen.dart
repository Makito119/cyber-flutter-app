import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key, required this.user});
  final Map<String, dynamic>? user;

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late Map<String, dynamic>? user;
  String pairingId = "";
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  Future<void> InputDialog(BuildContext context) async {
    print("ss");
    print(user!["pairing"]);
    //処理が重い(?)からか、非同期処理にする
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('タイトル'),
            content: TextField(
              onChanged: ((value) => pairingId = value),
              decoration: InputDecoration(hintText: "ここに入力"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('customers')
                      .doc(user!["cid"])
                      .update({
                    'pairing': {'id': pairingId, 'identity': false}
                  }).then((value) => Navigator.pop(context));
                  //OKを押したあとの処理
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcda8),
        title: const Text(
          "マイページ",
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
                top: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Color(0xffd1e8ff),
                    elevation: 10,
                    shadowColor: Color(0xffd1e8ff),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  名前: ${user!["name"]}',
                              style: const TextStyle(fontSize: 25.0)),
                          SizedBox(
                            height: 10,
                          ),
                          Text('  身分: ${user!["identity"]}',
                              style: const TextStyle(fontSize: 25.0)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(' メール: ${user!["email"]}',
                              style: const TextStyle(fontSize: 25.0)),
                        ]),
                  )),
            ),
            if (user!["identity"] == '子供' && !user!.containsKey('pairing'))
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: () {
                    InputDialog(context); //ペアリングの申請
                  },
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
            if (user!["identity"] == '親')
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: null,
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
      ),
    );
  }
}
