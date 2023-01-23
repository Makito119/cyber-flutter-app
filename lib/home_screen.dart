import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final Map<String, dynamic>? user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> FBjoblist = <String>[];
List<Widget> Listupitems(List<String> _JobList) {
  final List<Widget> jlist = <Widget>[];
  for (String s in _JobList) {
    jlist.add(Padding(padding: const EdgeInsets.all(4), child: Text(s)));
  }
  return jlist;
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  late Map<String, dynamic>? user;
  @override
  void initState() {
    user = widget.user;
    FBjoblist = <String>[];
    for (String value in user!['joblist']) {
      FBjoblist.add(value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcda8),
        title: const Text(
          'home',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Container(
                  color: const Color(0xffd1e8ff),
                  child: Center(
                    child: Text(
                      '手伝い総時間：＊＊時間',
                      style: TextStyle(color: Color(0xffde6464), fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2022, 4, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('これまでのお手伝い', style: TextStyle(fontSize: 24))),
              Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        collectRecords();
                      },
                      label: const Text('更新', style: TextStyle(fontSize: 16)),
                      icon: Icon(Icons.update)))
            ]),
            FBjoblist.length != 0
                ? Column(
                    children: Listupitems(FBjoblist),
                  )
                : SizedBox.shrink(),
          ]),
        ),
      ),
    );
  }

  Future collectRecords() async {
    final Snapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user!['cid'])
        .get();
    final data = Snapshot.data();
    List<String> _FBjoblist = <String>[];
    for (String value in data!['joblist']) {
      _FBjoblist.add(value);
    }
    setState(() {
      FBjoblist = _FBjoblist;
    });
  }
}
