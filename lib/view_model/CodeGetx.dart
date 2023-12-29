import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import '../model/Code.dart';
import '../model/question model.dart';
import 'database/local/cache_helper.dart';

class CodesGetX extends GetxController with SingleGetTickerProviderMixin {
  // List<Code> codeList = [];
  var docid;

  double? red, yellow, green;
  String typeCoins = 'none';
  int? withdrawal;
  TextEditingController priceController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  // getCode(int code) async {
  //   var codes = FirebaseFirestore.instance
  //       .collection('codes')
  //       .where('code', isEqualTo: code);
  //   var question = await codes.get();
  //   question.docs.forEach((element) {
  //     docid = element.id;
  //     update();
  //     codeList.add(Code.fromJson(element.data() as Map<String, dynamic>));
  //   });
  //
  //   print(codeList.toString());
  //
  //   return codeList;
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void delete(String id) async {
    await FirebaseFirestore.instance.collection('quiz').doc(id).delete();
    update();
  }

  updateApplied(
    bool applied,
  ) async {
    return await FirebaseFirestore.instance
        .collection('codes')
        .doc(docid)
        .update({'isApplied': applied});
  }

  checkCode(BuildContext context) async {
    List<Code> codeList = [];
    var codes = FirebaseFirestore.instance
        .collection('codes')
        .where('code', isEqualTo: codeController.text.toString());
    var question = await codes.get();

    question.docs.forEach((element) {
      docid = element.id;

      codeList.add(Code.fromJson(element.data() as Map<String, dynamic>));

      update();
    });

    if (codeList != null) {
      for (var element in codeList) {
        if (element.applied == false) {
          double red = CacheHelper.get(key: 'redCoins') ?? 0;
          double yellow = CacheHelper.get(key: 'yellowCoins') ?? 0;
          double green = CacheHelper.get(key: 'greenCoins') ?? 0;

          FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.get(key: 'uid'))
              .update({
            'redCoins':
                element.typeCoins == 'redCoins' ? red + element.price! : red,
            'greenCoins': element.typeCoins == 'greenCoins'
                ? green + element.price!
                : green,
            'yellowCoins': element.typeCoins == 'yellowCoins'
                ? yellow + element.price!
                : yellow,
          }).then((value) {
            element.typeCoins == 'redCoins'
                ? CacheHelper.put(key: 'redCoins', value: red + element.price!)
                : red;
            element.typeCoins == 'greenCoins'
                ? CacheHelper.put(
                    key: 'greenCoins', value: green + element.price!)
                : red;
            element.typeCoins == 'yellowCoins'
                ? CacheHelper.put(
                    key: 'yellowCoins', value: yellow + element.price!)
                : red;
            update();
          });

          updateApplied(true);

          Get.defaultDialog(title: '', content: Text('تمت العمليه بنجاح'))
              .then((value) {
            Get.back();
            Get.back();
            priceController.clear();
          });
        } else {
          Get.defaultDialog(title: '', content: Text('الكود غير صحيح'));
        }
      }
    } else
      Get.defaultDialog(title: '', content: Text('الكود غير صحيح'));
  }

  request() async {
    priceController.clear();

    await FirebaseFirestore.instance
        .collection('requests')
        .doc()
        .set({
      'name': CacheHelper.get(key: 'name'),
      'phone': CacheHelper.get(key: 'phone'),
      'uid': CacheHelper.get(key: 'uid'),
      'withdrawal': priceController.text,
      'typeCoins': typeCoins,
      'redCoins': CacheHelper.get(key: 'redCoins'),
      'greenCoins': CacheHelper.get(key: 'greenCoins'),
      'yellowCoins': CacheHelper.get(key: 'yellowCoins'),
    }).then((value) {
      Get.snackbar(
          '                              كيف حالك', '                 لقد تم ارسال الطلب في انتظار الموافقه',
          duration: Duration(seconds: 5),);
    });
  }
}
