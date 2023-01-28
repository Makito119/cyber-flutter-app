import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final Map<String, dynamic>? user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class FBJoblist_ID_DATE{
  FBJoblist_ID_DATE({required this.jobid, required this.starttime, required this.endtime});
  int jobid;
  DateTime starttime;
  DateTime endtime;
  int DurationofJob_m(){
    return endtime.difference(starttime).inMinutes;
  }
}
List<FBJoblist_ID_DATE> FBjoblist = <FBJoblist_ID_DATE>[];
List<Widget> Listupitems_fromIDDATE(List<FBJoblist_ID_DATE> _JobList) {
  final List<Widget> jlist = <Widget>[];
  for (FBJoblist_ID_DATE s in _JobList) {
    String ss="${s.starttime.month}月${s.starttime.day}日 ${s.starttime.hour}:${s.starttime.minute}   ID:${s.jobid}  ${s.DurationofJob_m()~/60}時間${s.DurationofJob_m()%60}分";
    jlist.add(Padding(padding: const EdgeInsets.all(4), child: Text(ss)));
  }
  return jlist;
}
bool givealert=false;



class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  late Map<String, dynamic>? user;
  @override
  void initState() {
    user = widget.user;
    FBjoblist = <FBJoblist_ID_DATE>[];
    for (String value in user!['joblist']) {
      List<String> value_splitted_in_string=value.split("%");
      FBjoblist.add(FBJoblist_ID_DATE(
          jobid: int.parse(value_splitted_in_string[0]),
          starttime: DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[1]),
          endtime: DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[2])));
    }
    super.initState();
    DateTime Sevendaysago=_focusedDay.subtract(Duration(days: 7));
    int Sevendaysjobtime=0;
    FBjoblist.forEach((date) {
      if(date.starttime.compareTo(Sevendaysago)>0){
        Sevendaysjobtime+=date.DurationofJob_m();
      }
    });
    if(Sevendaysjobtime>7*4*60){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) =>AlertDialogSample(
            user:user
          )
        );
      });
    }
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    children: Listupitems_fromIDDATE(FBjoblist),
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
    List<FBJoblist_ID_DATE> _FBjoblist_id_date=<FBJoblist_ID_DATE>[];
    for (String value in data!['joblist']) {
      List<String> value_splitted_in_string=value.split("%");

      _FBjoblist_id_date.add(FBJoblist_ID_DATE(
          jobid: int.parse(value_splitted_in_string[0]),
          starttime: DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[1]),
          endtime: DateFormat('yyyy-MM-dd-h:mm').parse(value_splitted_in_string[2])));
    }
    setState(() {
      FBjoblist=_FBjoblist_id_date;
    });
  }
}
class AlertDialogSample extends StatelessWidget{
  const AlertDialogSample({super.key, required this.user});
  final Map<String, dynamic>? user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox.shrink(),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      content: SingleChildScrollView(
        child:ListBody(
          children: <Widget>[
            user!['identity']=='子供'
            ?Image.asset('images/alert_child.png')
            :Image.asset('images/alert_parent.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop;
                  },
                  child:Text('今はしない'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child:Text('相談してみる'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        )
    ),
    );
  }
}
