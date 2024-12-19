import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../model/question model.dart';
import '../../../view_model/question_controller.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  final Option option;
  final String name;
  final String id;

  const QuestionCard({
    required this.option,
    required this.name,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine question type
    final isTrueFalse = option.type == '1';

    // True/False options
    List<String> tfQ = ['True', 'False'];

    // Multiple-choice options (null-safe filtering)
    List<String?> optionsQ = [
      option.option1,
      option.option2,
      option.option3,
      option.option4,
      option.option5,
    ].where((opt) => opt != null).toList();

    // Inject QuestionController
    QuestionController _controller = Get.put(QuestionController());

    return SingleChildScrollView(
      child: Container(
        height: 700,
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            // Display question text
            Text(
              option.question ?? "No question provided",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Generate true/false or multiple-choice options dynamically
            ...List.generate(
              isTrueFalse ? tfQ.length : optionsQ.length,
                  (index) => Options(
                index: index,
                text: isTrueFalse ? tfQ[index] : optionsQ[index]!,
                press: () {
                  _controller.checkAns(option, index, name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
