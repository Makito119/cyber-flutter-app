import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_kaji_app/home_screen.dart';
import 'package:cyber_kaji_app/homepage.dart';
import 'package:cyber_kaji_app/record_screen.dart';
import 'package:cyber_kaji_app/mypage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String name = "";
  String identity = "";
  late String _uid;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  List<DropdownMenuItem<int>> _items = [];
  int _selectItem = 0;

  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text(
          '親',
          style: TextStyle(fontSize: 20.0),
        ),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '子供',
          style: TextStyle(fontSize: 20.0),
        ),
        value: 2,
      ));
  }

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffcda8),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: "名前"),
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  // テキスト入力のラベルを設定
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      newUserEmail = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: "パスワード（６文字以上）"),
                  // パスワードが見えないようにする
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      newUserPassword = value;
                    });
                  },
                ),
                Row(
                  children: [
                    const Text(
                      '身分',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    DropdownButton(
                        items: _items,
                        value: _selectItem,
                        onChanged: (value) => {
                              setState(() {
                                _selectItem = value!;
                                if (value == 1) {
                                  identity = "親";
                                } else if (value == 2) {
                                  identity = '子供';
                                }
                              }),
                            }),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffff9a7e),
                      borderRadius: BorderRadius.circular(130),
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Center(
                      child: Text(
                        '新規登録',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: newUserEmail,
                        password: newUserPassword,
                      );
                      _uid = FirebaseAuth.instance.currentUser!.uid;
                      // 登録したユーザー情報
                      await customers.doc(_uid).set({
                        'name': name,
                        'email': newUserEmail,
                        'identity': identity,
                        'cid': _uid,
                        'joblist':FieldValue.arrayUnion([]),
                      });
                      final User user = result.user!;
                      print(user);
                      print(_uid);
                      setState(() {
                        infoText = "登録OK：${user.email}";
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      // 登録に失敗した場合
                      setState(() {
                        infoText = "登録NG：${e.toString()}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(infoText),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          ' or ',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(130),
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Center(
                      child: Text(
                        'ログインへ戻る',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
