import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_kaji_app/home_screen.dart';
import 'package:cyber_kaji_app/homepage.dart';
import 'package:cyber_kaji_app/record_screen.dart';
import 'package:cyber_kaji_app/mypage_screen.dart';
import 'package:cyber_kaji_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffcda8),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      loginUserEmail = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "パスワード"),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      loginUserPassword = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.signInWithEmailAndPassword(
                        email: loginUserEmail,
                        password: loginUserPassword,
                      );
                      // ログインに成功した場合
                      final User user = result.user!;
                      setState(() {
                        infoText = "ログインOK：${user.email}";
                      });
                      //ユーザデータを取得
                      final docRef = FirebaseFirestore.instance
                          .collection('customers')
                          .doc(user.uid); // DocumentReference
                      final docSnapshot =
                          await docRef.get(); // DocumentSnapshot
                      final data =
                          docSnapshot.exists ? docSnapshot.data() : null;
                      print(11);
                      print(data);
                      //ログイン成功後、ホームページに遷移
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    user: data,
                                  )));
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインNG：${e.toString()}";
                      });
                    }
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
                        'ログイン',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
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
                const SizedBox(height: 15),
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
                        '新規登録',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
