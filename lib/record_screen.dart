import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key, required this.user});
  final Map<String, dynamic>? user;
  // 状態を持ちたいので StatefulWidget を継承
  @override
  RecordPageState createState() => RecordPageState();
}

DateTime _focusedDay = DateTime.now();
DateTime _selectedDay = _focusedDay;
CalendarFormat _calendarFormat = CalendarFormat.week;
DateTime? _startTime;
DateTime? _endTime;
List<String> _joblist = <String>["家庭環境の維持", "介護・付き添い", "勤務(アルバイト等)"];
int _jobID = 0;
String _selectedJob = _joblist[0];
List<String> Tmode = <String>["タイマー", "時計から入力"];
String _selectedTmode = Tmode[0];
String recinfotext = "";

class RecordPageState extends State<RecordPage> {
  late Timer _timer; // この辺が状態
  late DateTime _time;
  final myController = TextEditingController();
  late Map<String, dynamic>? user;
  var _scrollController = ScrollController();
  @override
  // void initState() {
  //   // 初期化処理
  //   _time = DateTime.utc(0, 0, 0);
  //   super.initState();
  // }
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffcda8),
        title: const Text(
          '記録',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2022, 4, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                calendarFormat: _calendarFormat,
                locale: 'ja',
                //カレンダーの表示形式が変更された時の処理
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                //カレンダーの日付がタッチされた時の処理
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                    //_scrollController.animateTo(140, duration: Duration(milliseconds: 100), curve: Curves.easeOutBack);
                  }
                },
                daysOfWeekHeight: 32,
              ),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "仕事をした日",
                    style: TextStyle(fontSize: 16),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${_selectedDay.month}月${_selectedDay.day}日",
                    style: const TextStyle(fontSize: 24),
                  )),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "仕事内容",
                    style: TextStyle(fontSize: 16),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 32, 8),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedJob,
                  items: _joblist
                      .map((String list) => DropdownMenuItem(
                          value: list,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(list),
                          )))
                      .toList(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedJob = value ?? _joblist[0];
                    });
                  },
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, top: 8, right: 240),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedTmode,
                    items: Tmode.map((String list) => DropdownMenuItem(
                          value: list,
                          child: Text(list),
                        )).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedTmode = value ?? Tmode[0];
                      });
                    },
                  )),
              // Padding(
              //   padding: EdgeInsets.only(top: 28.0, bottom: 28.0),
              //   child: Clock(),
              // ),
              _selectedTmode == "タイマー"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _startTime = DateTime(
                                        _selectedDay.year,
                                        _selectedDay.month,
                                        _selectedDay.day,
                                        DateTime.now().hour,
                                        DateTime.now().minute);
                                  });
                                },
                                child: const Text(
                                  'スタート',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const Text(
                              "開始時刻",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              _startTime != null
                                  ? "${_startTime?.hour}:${_startTime?.minute}"
                                  : "--:--",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: (_startTime != null)
                                    ? () {
                                        setState(() {
                                          _endTime = DateTime(
                                              _selectedDay.year,
                                              _selectedDay.month,
                                              _selectedDay.day,
                                              DateTime.now().hour,
                                              DateTime.now().minute);
                                        });
                                      }
                                    : null,
                                child: const Text(
                                  'ストップ',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const Text(
                              "終了時刻",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              _endTime != null
                                  ? "${_endTime?.hour}:${_endTime?.minute}"
                                  : "--:--",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  pickTimeS(context);
                                },
                                child: const Text(
                                  '時刻設定',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const Text(
                              "開始時刻",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              _startTime != null
                                  ? "${_startTime?.hour}:${_startTime?.minute}"
                                  : "--:--",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  pickTimeE(context);
                                },
                                child: const Text(
                                  '時刻設定',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const Text(
                              "終了時刻",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              _endTime != null
                                  ? "${_endTime?.hour}:${_endTime?.minute}"
                                  : "--:--",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        )
                      ],
                    ),

              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 4),
                child: Text(
                  '作業時間',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    subtractjobtime(_startTime, _endTime),
                    style: const TextStyle(fontSize: 30),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed:
                          (subtractjobtime(_startTime, _endTime) != "--時間--分")
                              ? () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('customers')
                                        .doc(user!['cid'])
                                        .update({
                                      'joblist': FieldValue.arrayUnion([
                                        {
                                          'time':
                                              '${DateFormat('yyyy-MM-dd-H:m').format(_startTime!)}%${DateFormat('yyyy-MM-dd-H:m').format(_endTime!)}',
                                          'job': _selectedJob
                                        }
                                      ])
                                    });
                                    var a = await FirebaseFirestore.instance
                                        .collection('customers')
                                        .doc(user!['cid'])
                                        .get();
                                    double b = a['time'] +
                                        subtracttime(_startTime, _endTime);
                                    await FirebaseFirestore.instance
                                        .collection('customers')
                                        .doc(user!['cid'])
                                        .update({
                                      'time': double.parse(b.toStringAsFixed(2))
                                    });
                                    setState(() {
                                      recinfotext = "記録完了!";
                                    });
                                    waitsec();
                                  } catch (e) {
                                    // 登録に失敗した場合
                                    setState(() {
                                      recinfotext = "記録失敗：${e.toString()}";
                                      waitsec();
                                    });
                                  }
                                }
                              : null,
                      child: const Text(
                        '記録する',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Text(recinfotext))
            ],
          ),
        ),
      ),
    );
  }

  Future pickTimeS(BuildContext context) async {
    final newTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (newTime != null) {
      DateTime pickedtime = DateTime(_selectedDay.year, _selectedDay.month,
          _selectedDay.day, newTime.hour, newTime.minute);
      setState(() => {_startTime = pickedtime});
    } else {
      return;
    }
  }

  Future pickTimeE(BuildContext context) async {
    final newTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (newTime != null) {
      DateTime pickedtime = DateTime(_selectedDay.year, _selectedDay.month,
          _selectedDay.day, newTime.hour, newTime.minute);
      setState(() => {_endTime = pickedtime});
    } else {
      return;
    }
  }

  String subtractjobtime(DateTime? start, DateTime? end) {
    int dif;
    if (start != null && end != null) {
      DateTime NLs = start;
      DateTime NLe = end;
      dif = NLe.difference(NLs).inMinutes;
    } else {
      dif = -1;
    }
    if (dif < 0) {
      return "--時間--分";
    } else {
      return "${dif ~/ 60}時間${dif % 60}分";
    }
  }

  double subtracttime(DateTime? start, DateTime? end) {
    int dif;
    if (start != null && end != null) {
      DateTime NLs = start;
      DateTime NLe = end;
      dif = NLe.difference(NLs).inMinutes;
    } else {
      dif = -1;
    }
    if (dif < 0) {
      return 0;
    } else {
      return dif / 60;
    }
  }

  void waitsec() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        recinfotext = "";
      });
    });
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
