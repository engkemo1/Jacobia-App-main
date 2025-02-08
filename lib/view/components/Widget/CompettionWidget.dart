import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_count_down/date_count_down.dart';

import '../../pages/Compettition/compettitionDetails.dart';
import 'empty_widget.dart';

class CompetitionWidget extends StatelessWidget {
  final Stream<QuerySnapshot> competitionsStream =
      FirebaseFirestore.instance.collection('quiz').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: competitionsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.greenAccent),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, color: Colors.white, size: 80),
                const SizedBox(height: 10),
                const Text(
                  'لا يوجد مسابقات',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return snapshot.data!.docs.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyWidget(),
                  Text(
                    'no_competitions'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final startTime =
                      DateTime.parse('${doc['date']} ${doc['startTime']}');
                  final endTime =
                      DateTime.parse('${doc['date']} ${doc['EndTime']}');

                  return
                      // DateTime.now().isAfter(endTime)
                      //   ? const SizedBox.shrink() // Skip expired competitions
                      //   :
                      GestureDetector(
                    onTap: () => _navigateToCompetitionDetails(context, doc),
                    child: _buildCompetitionCard(context, doc, startTime),
                  );
                },
              );
      },
    );
  }

  Widget _buildCompetitionCard(
      BuildContext context, dynamic doc, DateTime startTime) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildImageSection(doc['imageUrl'], startTime),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    doc['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(color: Colors.white,height: 1,width: 100,),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${"goal".tr}:',
                      style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 150,
                      child: Text(
                        'rank_condition'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 8),
                Container(color: Colors.white,height: 1,width: 100,),
                const SizedBox(height: 8),


                Text(
                  '${"price".tr}: ${doc['price']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      doc['typeCoins'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    Image.asset('assets/images/coin.png', width: 20),
                  ],
                ),

              ],

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imageUrl, DateTime startTime) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            errorBuilder: (context, err, s) => Image.asset(
              "assets/images/placeholder.jpg",
              width: 130,
              height: 180,
              fit: BoxFit.cover,
            ),
            imageUrl,
            width: 130,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          left: 10,right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                CountDownText(
                  due: startTime,
                  finishedText: "done".tr,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToCompetitionDetails(BuildContext context, dynamic doc) {
    // Navigate to details screen with relevant data.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompettitionDetails(
          typeCoins: doc['typeCoins'],
          date: doc['date'],
          docId: doc.id,
          image: doc['imageUrl'],
          desc: doc['desc'],
          max: doc['max'],
          min: doc['min'],
          price: doc['price'],
          name: doc['name'],
          profit: doc['profit'],
          categories: doc['selected'],
          r1: doc['Rank1'],
          r2: doc['Rank2'],
          r3: doc['Rank3'],
          r4: doc['Rank4'],
          r5: doc['Rank5'],
          r6: doc['Rank6'],
          r7: doc['Rank7'],
          r8: doc['Rank8'],
          r9: doc['Rank9'],
          r10: doc['Rank10'],
          endTime: doc['EndTime'],
          startTime: doc['startTime'],
        ),
      ),
    );
  }
}
