import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jacobia/view/pages/Quiz/quiz_screen.dart';
import 'package:jacobia/view/pages/waitting.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import 'package:supercharged/supercharged.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';

import '../../../view_model/AuthGetX/AuthController.dart';
import '../../../view_model/getx/enroll.dart';

class CompettitionDetails extends StatefulWidget {
  final String desc;
  final String image;
  final String docId;
  final String date;
  final String typeCoins;
  final int max;
  final int min;
  final double price;
  final double profit;
  final String name;
  final String endTime;
  final String startTime;

  final List categories;
  final int? r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;

  const CompettitionDetails({
    super.key,
    required this.typeCoins,
    required this.date,
    required this.desc,
    required this.max,
    required this.min,
    required this.price,
    required this.profit,
    required this.name,
    required this.categories,
    required this.image,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.r5,
    required this.r6,
    required this.r7,
    required this.r8,
    required this.r9,
    required this.r10,
    required this.docId,
    required this.endTime,
    required this.startTime,
  });

  @override
  State<CompettitionDetails> createState() => _CompettitionDetailsState();
}

class _CompettitionDetailsState extends State<CompettitionDetails> {
  int _index = 0;
  var enroll = Get.put(EnrollGetX());
  bool isEnrolled = false;
  Enrolled()async{

    await FirebaseFirestore.instance
        .collection("users")
        .doc(CacheHelper.get(key: 'uid'))
        .collection("enrolled_quiz")
        .doc(widget.docId)
        .get().then((value) {
      if(value.exists){
setState(() {
  isEnrolled=true;

});
      }else{
        setState(() {
          isEnrolled=false;

        });

      }
    });
    print(isEnrolled);
  }

  @override
  void initState() {
    Enrolled();
    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var startDate = DateTime.parse('${widget.date} ${widget.startTime}');
    var endDate = DateTime.parse('${widget.date} ${widget.endTime}');

    String d = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    var dateNow = DateTime.parse(d);
    print(widget.categories);
    var list = CacheHelper.get(key: 'enrolled') ?? [];

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(gradient: newVv),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // #signup_text
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black38),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 45,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white70,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: primaryColor,
                                    size: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  widget.name ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Arial'),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 45,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white70,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      const Icon(
                                        Icons.notifications,
                                        color: primaryColor,
                                        size: 25,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(top: 5),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffc32c37),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: Center(
                                              child: Text(
                                                '1',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: Image.network(widget.image),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Description: ${widget.desc}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Expanded(
                                            child: Divider(
                                          thickness: 2,
                                        ))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'price:  ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                '${widget.price}  ${widget.typeCoins} ',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                              ),
                                              Image.asset(
                                                'assets/images/coin.png',
                                                width: 15,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Categories: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Wrap(
                                                children: List.generate(
                                              widget.categories.length,
                                              (index) => Text(
                                                ' ${widget.categories[index]} ${widget.categories.lastIndex == index ? "" : ","}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    DataTable(
                                      columnSpacing: 20,
                                      headingTextStyle: TextStyle(
                                          color: primaryColor, fontSize: 10),
                                      dataTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      rows: [
                                        DataRow(cells: [
                                          DataCell(Text("${widget.r1}%")),
                                          DataCell(Text("${widget.r2}%")),
                                          DataCell(Text("${widget.r3}%")),
                                          DataCell(Text("${widget.r4}%")),
                                          DataCell(Text("${widget.r5}%")),
                                        ]),
                                      ],
                                      columns: const [
                                        DataColumn(
                                          label: Center(
                                            child: Text(
                                              'Rank1',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank2',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank3',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank4',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank5',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataTable(
                                      columnSpacing: 20,
                                      headingTextStyle: TextStyle(
                                          color: primaryColor, fontSize: 10),
                                      dataTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      rows: [
                                        DataRow(cells: [
                                          DataCell(Text("${widget.r6}%")),
                                          DataCell(Text("${widget.r7}%")),
                                          DataCell(Text("${widget.r8}%")),
                                          DataCell(Text("${widget.r9}%")),
                                          DataCell(Text("${widget.r10}%")),
                                        ]),
                                      ],
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Rank6',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank7',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank8',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank9',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Rank10',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'How can i join',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Theme(
                                data: ThemeData(
                                    colorScheme: const ColorScheme.light(
                                  primary: Colors.transparent,
                                )),
                                child: Stepper(
                                  currentStep: _index,
                                  onStepCancel: () {
                                    if (_index > 0) {
                                      setState(() {
                                        _index -= 1;
                                      });
                                    }
                                  },
                                  onStepContinue: () {
                                    if (_index <= 0) {
                                      setState(() {
                                        _index += 1;
                                      });
                                    }
                                  },
                                  onStepTapped: (int index) {
                                    setState(() {
                                      _index = index;
                                    });
                                  },
                                  steps: <Step>[
                                    Step(
                                      title: const Text('Step 1 '),
                                      content: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                      'Join The Callenge'),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(widget.price.toString()),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Image.asset(
                                                    'assets/images/coin.png',
                                                    height: 15,
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                    const Step(
                                      title: Text('Step 2'),
                                      content: Text(
                                          'you should be in rank1 to 10 to win '),
                                    ),
                                  ],
                                ),
                              )),
                          Center(
                              child: isEnrolled == false
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              dateNow.isBefore(startDate)
                                                  ? Colors.black38
                                                  : Colors.grey,
                                          maximumSize: Size(200, 100),
                                          fixedSize: Size(160, 30),
                                          minimumSize: Size(20, 40)),
                                      onPressed: () {
                                        if (dateNow.isBefore(startDate)) {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                title:
                                                    const Text('Are you sure'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                          'Your Balance will reduce ${widget.price}'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () {
                                                        enroll
                                                            .enroll(
                                                                widget
                                                                    .typeCoins,
                                                                widget.price,
                                                                widget.name,
                                                                widget.docId)
                                                            .then((value) {
                                                          if (value == true) {
                                                            setState(() {
                                                              isEnrolled = true;
                                                            });
                                                          }
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          Get.snackbar('!تنبيه',
                                              'انتهى وقت الانضمام للمسابقة ');
                                        }
                                      },
                                      child: dateNow.isBefore(startDate)
                                          ? Text('Enroll')
                                          : Text('Done'))
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              dateNow.isBefore(startDate)
                                                  ? Colors.grey
                                                  : Colors.black38,
                                          maximumSize: Size(200, 100),
                                          fixedSize: Size(160, 30),
                                          minimumSize: Size(20, 40)),
                                      onPressed: () async {
                                        if (endDate.isAfter(dateNow)) {
                                          if (startDate.isAfter(dateNow)) {
                                            Get.snackbar(
                                                '!تنبيه', 'لم تبدأ بعد');
                                          } else {
                                            bool isJoined = false;
                                            await FirebaseFirestore.instance
                                                .collection(widget.name)
                                                .doc()
                                                .collection('enrolled')
                                                .doc(
                                                    CacheHelper.get(key: 'uid'))
                                                .get()
                                                .then((value) {
                                              if (value.exists) {
                                                isJoined = true;
                                                setState(() {});
                                              } else {
                                                isJoined = false;
                                                setState(() {});
                                              }
                                            });
                                            if (isJoined == false) {
                                              Get.put(EnrollGetX()).onBeginQuiz(
                                                  widget.name,
                                                  widget.typeCoins,
                                                  widget.docId,
                                                  widget.r1,
                                                  widget.r2,
                                                  widget.r3,
                                                  widget.r4,
                                                  widget.r5,
                                                  widget.r6,
                                                  widget.r7,
                                                  widget.r8,
                                                  widget.r9,
                                                  widget.r10);
                                              Get.to(Waiting(
                                                name: widget.name,
                                                list: widget.categories,
                                                id: widget.docId,
                                                dateTime: endDate,
                                              ));
                                            } else {
                                              Get.snackbar('!تنبيه',
                                                  'لقد انضميت من قبل بالفعل');
                                            }
                                          }
                                        } else {
                                          Get.snackbar('!تنبيه',
                                              'انتهى وقت الانضمام للمسابقة ');
                                        }
                                      },
                                      child: dateNow.isAfter(endDate)
                                          ? Text('Done')
                                          : Text('Start'))),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
