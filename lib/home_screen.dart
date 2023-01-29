import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final Map<String, dynamic>? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class FBJoblist_ID_DATE {
  FBJoblist_ID_DATE(
      {required this.starttime, required this.endtime, required this.job});
  String job;
  DateTime starttime;
  DateTime endtime;
  int DurationofJob_m() {
    return endtime.difference(starttime).inMinutes;
  }
}

const url =
    "https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/kodomo/kodomo_kosodate/zisouichiran.html";
List<FBJoblist_ID_DATE> FBjoblist = <FBJoblist_ID_DATE>[];
List<Widget> Listupitems_fromIDDATE(List<FBJoblist_ID_DATE> _JobList) {
  final List<Widget> jlist = <Widget>[];
  for (FBJoblist_ID_DATE s in _JobList) {
    String ss =
        "${s.job}  ${s.starttime.month}月${s.starttime.day}日 ${s.starttime.hour}:${s.starttime.minute}  ${s.DurationofJob_m() ~/ 60}時間${s.DurationofJob_m() % 60}分";
    jlist.add(Padding(padding: const EdgeInsets.all(4), child: Text(ss)));
  }
  return jlist;
}

final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid.toString();
bool givealert = false;

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  late Map<String, dynamic>? user;
  var visibility = true;
  late num time = 0;
  Future<String> initilize(uid) async {
    final Snapshot =
        await FirebaseFirestore.instance.collection('customers').doc(uid).get();
    user = Snapshot.data();
    print(user);
    for (Map value in user!['joblist']) {
      List<String> value_splitted_in_string = value['time'].split("%");
      FBjoblist.add(FBJoblist_ID_DATE(
          job: value['job'],
          starttime:
              DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[0]),
          endtime: DateFormat('yyyy-MM-dd-h:mm')
              .parse(value_splitted_in_string[1])));
    }
    DateTime Sevendaysago = _focusedDay.subtract(Duration(days: 7));
    int Sevendaysjobtime = 0;
    FBjoblist.forEach((date) {
      if (date.starttime.compareTo(Sevendaysago) > 0) {
        Sevendaysjobtime += date.DurationofJob_m();
      }
    });
    if (Sevendaysjobtime > 7 * 4 * 60) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialogSample(user: user));
      });
    }
    return '';
  }

  var FBjoblist = <FBJoblist_ID_DATE>[];
  @override
  void initState() {
    super.initState();
    user = widget.user;
    time = widget.user!['time'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcda8),
        title: const Text(
          'ホーム',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: FutureBuilder(
                future: initilize(user!['cid']),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Container(
                            color: const Color(0xffd1e8ff),
                            child: Center(
                              child: Text(
                                '今週手伝い総時間：${user!['time']}時間',
                                style: TextStyle(
                                    color: Color(0xffde6464), fontSize: 24),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(
                                color: const Color(0xffd1e8ff),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Container(
                                    color: const Color(0xffd1e8ff),
                                    child: Center(
                                      child: Text(
                                        'これまでの手伝い',
                                        style: TextStyle(
                                            color: Color(0xffde6464),
                                            fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                      FBjoblist.length != 0
                          ? Column(
                              children: Listupitems_fromIDDATE(FBjoblist),
                            )
                          : SizedBox.shrink(),
                    ]);
                  }
                  return Text('loading');
                })),
      ),
    );
  }

  Future collectRecords() async {
    final Snapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user!['cid'])
        .get();
    final data = Snapshot.data();
    List<FBJoblist_ID_DATE> _FBjoblist_id_date = <FBJoblist_ID_DATE>[];
    for (Map value in data!['joblist']) {
      List<String> value_splitted_in_string = value['time'].split("%");

      _FBjoblist_id_date.add(FBJoblist_ID_DATE(
          job: value['job'],
          starttime:
              DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[0]),
          endtime: DateFormat('yyyy-MM-dd-h:mm')
              .parse(value_splitted_in_string[1])));
    }
    setState(() {
      user = data;
      time = data['time'];
      FBjoblist = _FBjoblist_id_date;
    });
  }
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({super.key, required this.user});
  final Map<String, dynamic>? user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox.shrink(),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      content: SingleChildScrollView(
          child: ListBody(
        children: <Widget>[
          user!['identity'] == '子供'
              ? Image.asset('images/alert_child.png')
              : Image.asset('images/alert_parent.png'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('今はしない'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await launchUrl(
                      Uri.parse(url),
                    );
                  } catch (err) {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('相談してみる'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
