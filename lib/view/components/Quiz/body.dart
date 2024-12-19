import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../view_model/question_controller.dart';
import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  final String name;
  final List list;
  final String id;

  const Body({Key? key, required this.name, required this.list, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());

    return Container(
      decoration: BoxDecoration(gradient: newVv),
      child: FutureBuilder(
        future: _questionController.getQuestions(list),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
            );
          } else {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ProgressBar(),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GetBuilder<QuestionController>(
                          builder: (_) => Text.rich(
                            TextSpan(
                              style: const TextStyle(color: Colors.white),
                              text: "Question ${_questionController.questionNumber}",
                              children: [
                                TextSpan(text: "/${_questionController.options.length}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _questionController.pageController,
                          onPageChanged: _questionController.updateTheQnNum,
                          itemCount: _questionController.options.length,
                          itemBuilder: (context, index) {
                            return QuestionCard(
                              name: name,
                              id: id,
                              option: _questionController.options[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
