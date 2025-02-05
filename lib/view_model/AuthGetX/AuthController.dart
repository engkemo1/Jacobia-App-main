import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:jacobia/view/pages/authentication/login.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import '../../model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../view/pages/MainScreen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Rx<User?> _user;
  String? name;
  FirebaseAuth auth = FirebaseAuth.instance;
  var isSignedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCoins();
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => SignIn());
    } else {
      Get.offAll(() => MainScreen());
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _handleUser(user);
      }

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        return null;
      }

      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _handleUser(user);
      }

      return user;
    } catch (e) {
      print("Error signing in with Facebook: $e");
      return null;
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
      var h = CacheHelper.sharedPreferences.getStringList('enrolled') ?? [];
      var t = h.add(docId);
      l.add(docId);
      CacheHelper.get(key: 'enrolled') == null
          ? await CacheHelper.sharedPreferences.setStringList('enrolled', l)
          : await CacheHelper.sharedPreferences.setStringList('enrolled', h);

      Get.defaultDialog(
          content: const Text(
            'Enrolled',
            style: TextStyle(color: Colors.white),
          ),
          title: '',
          backgroundColor: Colors.black);
      update();
    });
  }
  Future<void> _handleUser(User user) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // If the user doesn't exist, create a new user document
        UserModel newUser = UserModel(
          createdAt: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          pass: '',
          name: user.displayName ?? 'No Name',
          email: user.email ?? 'No Email',
          uid: user.uid,
          phone: '',
          nationality: '',
          profilePhoto: user.photoURL??'',
          nick: '',
          address: '',
          greenCoins: 0,
          redCoins: 0,
          yellowCoins: 0,
        );
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(newUser.toJson());
        _saveUser(newUser);
      } else {
        // If the user exists, fetch data
        UserModel userModel = UserModel.fromSnap(userDoc);
        _saveUser(userModel);
      }
    } catch (e) {
      print("Error handling user data: $e");
    }
  }

  _saveUser(UserModel user) async {
    CacheHelper.put(key: 'date', value: user.createdAt!);
    CacheHelper.put(key: 'uid', value: user.uid??"");
    CacheHelper.put(key: 'name', value: user.name??"");
    CacheHelper.put(key: 'email', value: user.email??"");
    CacheHelper.put(key: 'phone', value: user.phone??"");
    CacheHelper.put(key: 'nationality', value: user.nationality ?? "");
    CacheHelper.put(key: 'password', value: user.pass??"");
    CacheHelper.put(key: 'imageUrl', value: user.profilePhoto??"");
    CacheHelper.put(key: 'address', value: user.address??"");
    CacheHelper.put(key: 'nick', value: user.nick??"");
    CacheHelper.put(key: 'redCoins', value: user.redCoins);
    CacheHelper.put(key: 'yellowCoins', value: user.yellowCoins);
    CacheHelper.put(key: 'greenCoins', value: user.greenCoins);
  }

  void getCoins() {
    var docs = FirebaseFirestore.instance.collection('users').doc(CacheHelper.get(key: 'uid'));
    docs.get().then((value) async {
      CacheHelper.put(key: 'redCoins', value: value.get('redCoins'));
      CacheHelper.put(key: 'greenCoins', value: value.get('greenCoins'));
      CacheHelper.put(key: 'yellowCoins', value: value.get('yellowCoins'));
      CacheHelper.put(key: 'uid', value: value.get('uid'));
    });
  }

  void registerUser(String username, String email, String password, String phone, String nick, String nation, String address) async {
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      UserModel user = UserModel(
        createdAt: DateFormat("yyyy-MM-dd").format(DateTime.now()),
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
        yellowCoins: 0,
      );
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set(user.toJson());
      _saveUser(user);
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => getUser(email: email));
      } else {
        Get.snackbar('Error Logging in', 'Please enter all the fields',backgroundColor: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error Loggin gin', e.toString(),backgroundColor: Colors.white);
    }
  }

  Future<void> getUser({required String email}) async {
    await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((value) {
      for (var result in value.docs) {
        UserModel user = UserModel.fromSnap(result);
        _saveUser(user);
      }
    });
  }

  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.back();
    } catch (e) {
      Get.snackbar('Error occurred!', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signout() async {
    try {
      await auth.signOut().then((value) => CacheHelper.clearData());
      isSignedIn.value = false;
      Get.offAll(() => SignIn());
    } catch (e) {
      Get.snackbar('Error occurred!', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}

extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
