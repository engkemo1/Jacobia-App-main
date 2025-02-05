import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../view_model/database/local/cache_helper.dart';
import '../components/Widget/PlayerRank1.dart';
import '../components/Widget/empty_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(gradient: newVv),
            child: Column(
              children: [
SizedBox(height: 20,),                /// Profile & Notification Section
                buildProfileHeader(),

                /// Results Section
                Expanded(
                  child: Container(
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Results').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return buildEmptyResults();
                        } else {
                          return buildResultsList(snapshot);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile & Notification Header
  Widget buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black38),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Profile Info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CacheHelper.get(key: 'imageUrl') == null
                      ? const AssetImage('assets/icons/logo.png')
                      : NetworkImage(CacheHelper.get(key: 'imageUrl')) as ImageProvider,
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  CacheHelper.get(key: 'name') ?? '',
                  style: const TextStyle(fontFamily: 'Arial', color: Colors.white, fontSize: 17, decoration: TextDecoration.none),
                ),
              ],
            ),

            /// Notification Icon
            Container(
              height: 50,
              width: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white70),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications, color: primaryColor, size: 30),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xffc32c37), border: Border.all(color: Colors.white, width: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty Results Widget
  Widget buildEmptyResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyWidget(),
        Text("no_results".tr, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  /// Results List
  Widget buildResultsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: [
        SizedBox(
          height: Get.height - 250,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var result = snapshot.data!.docs[index];
              return PlayerRank1(
                image: result['imageUrl'],
                name: result['name'],
                prize: result['prize'].toString(),
                score: result['score'].toString(),
                quizName: result['quizName'],
              );
            },
          ),
        ),
        SizedBox(height: Get.height * 0.01),
      ],
    );
  }
}
