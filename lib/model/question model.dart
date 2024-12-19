class Option {
  int? answer; // Can handle String, Boolean, or other types
  dynamic type; // "option" in this case
  String? selected;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? option5;
  String? question;

  Option({
    required this.answer,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.option5,
    required this.selected,
    required this.type,
    required this.question,
  });

  // Parsing Firestore data
  Option.fromJson(Map<dynamic, dynamic> map) {
    type = map['type'].toString();
    option1 = map['option1'] as String?;
    option2 = map['option2'] as String?;
    option3 = map['option3'] as String?;
    option4 = map['option4'] as String?;
    option5 = map['option5'] as String?;
    question = map['question'] as String?;
    selected = map['selected'] as String?;


      answer = map['answer'];

  }
}
