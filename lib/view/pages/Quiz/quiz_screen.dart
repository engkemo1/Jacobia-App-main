import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/Quiz/body.dart';

class QuizScreen extends StatelessWidget {
  final String name;
  final List<dynamic> list;
  final String id;

  const QuizScreen(
      {super.key, required this.name, required this.list, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: SizedBox(),
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: WillPopScope(
        child: Body(name: name, list: list, id: id),
        onWillPop: () async {
          return await Get.defaultDialog(
                  title: '',
                  content: Center(child:Text("هل انتا متاكد من الخروج",)),
                  onConfirm: () {
                    exit(0);
                  },
                  onCustom: () {
                    Navigator.of(context).canPop();
                  },
                )
              ;
        },
      ),
    );
  }
}
