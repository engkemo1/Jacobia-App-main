import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String description;
  final double amount;
  final String currency;
  final List<dynamic> categories;
  final List<dynamic> ranks;

  const ProductCard({
    Key? key,
    required this.image,
    required this.description,
    required this.amount,
    required this.currency,
    required this.categories,
    required this.ranks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black54,
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(image),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${"description".tr}:  ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${"price".tr}:  ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$amount $currency',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    'assets/images/coin.png',
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${"categories".tr}:  ',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Wrap(
                  spacing: 15,
                  children: categories
                      .map((category) => Text(
                    category,
                    style: const TextStyle(color: Colors.white),
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _buildRankGrid(ranks.sublist(0, 5), 1),
          const SizedBox(height: 10),
          _buildRankGrid(ranks.sublist(5, 10), 6),
        ],
      ),
    );
  }

  Widget _buildRankGrid(List<dynamic> rankValues, int startRank) {
    return Column(
      children: [
        Row(
          children: List.generate(
            rankValues.length,
                (index) => Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  '${"rank".tr} ${startRank + index}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500,),textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: List.generate(
            rankValues.length,
                (index) => Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white),
                ),
                child: Text(
                  '${rankValues[index]??0}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
