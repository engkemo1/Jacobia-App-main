
import 'dart:async';

import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';

import 'Quiz/quiz_screen.dart';

class Waiting extends StatefulWidget {
  const Waiting({Key? key, required this.name, required this.list, required this.id, required this.dateTime}) : super(key: key);
  final String name;
  final List<dynamic> list;
  final String id;
 final  DateTime  dateTime;

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {

  @override
  void initState() {

    Duration diff = widget.dateTime.difference(DateTime.now());
    Timer(Duration(seconds: diff.inSeconds), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(name: widget.name, list: widget.list, id: widget.id,)));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height:100,child: Image.asset('assets/icons/logo.png')),
          SizedBox(height: 10,),
          Center(
            child: Text('The Quiz will begin in be ready ):'),
          ),
          CountDownText(
            due: widget.dateTime,
            finishedText: "Done",
            showLabel: true,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15),
          ),


        ],
      ),
    );
  }
}
