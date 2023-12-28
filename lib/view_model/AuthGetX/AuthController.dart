import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:jacobia/view/pages/authentication/login.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import '../../model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../view/pages/MainScreen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  String? name;

  User get user => _user.value!;

  var displayName = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  var isSignedIn = false.obs;

  User? get userProfile => auth.currentUser;
  bool enrolled = false;
  String? emailq;
@override
  void onInit() {
  getCoins();
    super.onInit();
  }
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => SignIn());
    } else {
      Get.offAll(() => MainScreen());
    }
  }

  enrolledQuiz(var docId) async {
    List<String> l = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.get(key: 'uid'))
        .collection('enrolled_quiz')
        .doc(docId)
        .set({'id': docId}).then((value) async {
     var h=CacheHelper.sharedPreferences.getStringList('enrolled')?? [];
     var t=h.add(docId);
      l.add(docId);
      CacheHelper.get(key:'enrolled') == null
          ? await CacheHelper.sharedPreferences.setStringList('enrolled', l)
          :await CacheHelper.sharedPreferences.setStringList('enrolled', h);

      Get.defaultDialog(content: const Text('Enrolled'), title: '');
      update();
    });
  }

  getCoins(){
  var docs=  FirebaseFirestore.instance.collection('users').doc(CacheHelper.get(key: 'uid'));

    docs.get().then((value) async{

      CacheHelper.put(key: 'redCoins', value: value.get('redCoins'));
      CacheHelper.put(key: 'greenCoins', value: value.get('greenCoins'));
      CacheHelper.put(key: 'yellowCoins', value: value.get('yellowCoins'));
      CacheHelper.put(key: 'uid', value: value.get('uid'));

    });


  }

  void registerUser(String username, String email, String password,
      String phone, String nick, String nation, String address) async {
    try {
      // save out user to our ath and firebase firestore
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailq = email;
      // String downloadUrl = await _uploadToStorage(image);
      UserModel user = UserModel(
        pass: password,
          name: username,
          email: email,
          uid: cred.user!.uid,
          phone: phone,
          nationality: nation,
          nick: nick,
          address: address,
          greenCoins: 0,
          redCoins: 0,
          yellowCoins: 0);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());

      _saveUser(user);
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  _saveUser(UserModel user) async {
    log("email: ${user.uid}");

    CacheHelper.put(key: 'uid', value: user.uid!);
    CacheHelper.put(key: 'name', value: user.name!);
    CacheHelper.put(key: 'email', value: user.email!);
    CacheHelper.put(key: 'phone', value: user.phone!);
    CacheHelper.put(key: 'nationality', value: user.nationality!);
    CacheHelper.put(key: 'password', value: user.pass!);
    CacheHelper.put(key: 'imageUrl', value: user.profilePhoto!);
    CacheHelper.put(key: 'address', value: user.address!);
    CacheHelper.put(key: 'nick', value: user.nick!);
    CacheHelper.put(key: 'redCoins', value: user.redCoins);
    CacheHelper.put(key: 'yellowCoins', value: user.yellowCoins);
    CacheHelper.put(key: 'greenCoins', value: user.greenCoins);
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => getUser(email: email));
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  Future<void> getUser({required String email}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      for (var result in value.docs) {
        UserModel user = UserModel(
          pass: result.get('password'),
          uid: result.id,
          email: result.get('email'),
          name: result.get('name'),
          phone: result.get('phone'),
          address: result.get('address'),
          nick: result.get('nick'),
          profilePhoto: result.get('profilePhoto'),
          redCoins: result.get('redCoins'),
          yellowCoins: result.get('yellowCoins'),
          greenCoins: result.get('greenCoins'),
        );

        print(result.id);
        _saveUser(user);
      }
    });
  }

  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.back();
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;

      String message = '';

      if (e.code == 'user-not-found') {
        message =
            ('The account does not exists for $email. Create your account by signing up.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.white);
    }
  }

  void signout() async {
    try {
      await auth.signOut();
      isSignedIn.value = false;
      CacheHelper.clearData();

      update();
      Get.offAll(() => SignIn());
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.white);
    }
  }
}

// // to capitalize first letter of a Sting
extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
