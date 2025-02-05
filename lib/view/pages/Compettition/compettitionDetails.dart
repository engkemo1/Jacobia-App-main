import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jacobia/view/pages/Compettition/widgets/product_card.dart';
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

  final List<dynamic> categories;
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

  Enrolled() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(CacheHelper.get(key: 'uid'))
        .collection("enrolled_quiz")
        .doc(widget.docId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isEnrolled = true;
        });
      } else {
        setState(() {
          isEnrolled = false;
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
                          ProductCard(
                            image: widget.image,
                            description: widget.desc,
                            amount: widget.price,
                            currency: widget.typeCoins,
                            categories: widget.categories,
                            ranks: [
                              widget.r1,
                              widget.r2,
                              widget.r3,
                              widget.r4,
                              widget.r5,
                              widget.r6,
                              widget.r7,
                              widget.r8,
                              widget.r9,
                              widget.r10
                            ],
                          ),
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'how_can_i_join'.tr,
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
                                      title:  Text('step_1'.tr,style: TextStyle(fontWeight: FontWeight.w600),),
                                      content: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                   Text(
                                                      'join_the_challenge'.tr),
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
                                     Step(
                                      title: Text('step_2'.tr,style: TextStyle(fontWeight: FontWeight.w600),),
                                      content: Text(
                                          'rank_condition'.tr),
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
                                                     Text('are_you_sure'.tr),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                          '${"enrollment_warning".tr} ${widget.price}'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                      child:  Text('yes'.tr),
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
                                                    child:  Text('no'.tr),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          Get.snackbar('warning'.tr, 'join_time_ended'.tr,backgroundColor: Colors.white);

                                        }
                                      },
                                      child: dateNow.isBefore(startDate)
                                          ? Text('enroll'.tr)
                                          : Text('done'.tr))
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
                                                'warning'.tr, 'not_started'.tr);
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
                                              Get.snackbar('warning'.tr,
                                                  "already_joined".tr,backgroundColor: Colors.white);
                                            }
                                          }
                                        } else {
                                          Get.snackbar('warning'.tr,'join_time_ended'.tr
                                              ,backgroundColor: Colors.white);
                                        }
                                      },
                                      child: dateNow.isAfter(endDate)
                                          ? Text('done'.tr)
                                          : Text('start'.tr))),
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
