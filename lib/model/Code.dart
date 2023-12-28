
class Code {
  bool ?applied;
  String? code;
  String? typeCoins;
  var price;


  Code({
    required this.price,
    required this.applied,
    required this.code,
    required this.typeCoins,
  });


  Code.fromJson(Map<dynamic, dynamic> map) {
    applied = map['isApplied'];
    code = map['code'];
    typeCoins = map['typeCoins'];
    price = map['price'];
  }
}
