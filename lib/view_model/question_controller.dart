import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:jacobia/view/pages/MainScreen.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import '../model/question model.dart';
import '../view/pages/Quiz/after_game_screen.dart';

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  List<Option> options = [];
  List<Option> TrueFalse = [];

  List rank = [];

  int? rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10;
  var total;

  getQuestions(List s) async {
    var questions = FirebaseFirestore.instance
        .collection('question')
        .where('selected', whereIn: s);

    var question = await questions.get();
    print(question);

    var optionsSnapshot = question.docs.forEach((element) {
      options.add(Option.fromJson(element.data() as Map<String, dynamic>));
    });
    print(options);
    return optionsSnapshot;
  }

  deleteQuiz() {
    FirebaseFirestore.instance
        .collection('quiz')
        .doc(CacheHelper.get(key: 'quiz'))
        .delete();
  }

  getRank(String collection) async {
    var getRank = await FirebaseFirestore.instance.collection(collection).get();

    getRank.docs.forEach((element) {
      if (element.data().isNotEmpty) {
        rank.add(element.data()['correctAnswer']);
        rank.sort();
      }
    });

    rank1 = rank.elementAt(rank.length - 1);
    rank2 = rank.elementAt(rank.length - 2);
    rank3 = rank.elementAt(rank.length - 3);
    rank4 = rank.elementAt(rank.length - 4);
    rank5 = rank.elementAt(rank.length - 5);
    rank6 = rank.elementAt(rank.length - 6);
    rank7 = rank.elementAt(rank.length - 7);
    rank8 = rank.elementAt(rank.length - 8);
    rank9 = rank.elementAt(rank.length - 9);
    rank10 = rank.elementAt(rank.length - 10);

  }

  getTotal(String docId) async {
   await FirebaseFirestore.instance
        .collection('total')
        .doc(docId)
        .get().then((value) {
      total=value.get('total');
      print(total);
      print(value.get('total'));
    });
    print(total.toString());
  }

  AnimationController? _animationController;
  Animation? _animation;

// so that we can access our animation outside
  Animation? get animation => this._animation;

  PageController? _pageController;

  PageController? get pageController => this._pageController;

  bool _isAnswered = false;

  bool get isAnswered => this._isAnswered;

  int? _correctAns;

  int? get correctAns => this._correctAns;

  int? _selectedAns;

  int? get selectedAns => this._selectedAns;

// for more about obs please check documentation
  var _questionNumber = 0;

  get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;

  int get numOfCorrectAns => this._numOfCorrectAns;

// called immediately after the widget is allocated memory
  @override
  void onInit() {
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 25), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController?.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

// // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _animationController!.dispose();
    _pageController!.dispose();
  }

  void checkAns(
      Option question,
      int selectedIndex,
      String qName,
      ) {
    // Store selected quiz name in cache
    CacheHelper.put(key: 'quiz', value: qName);

    _isAnswered = true;
    _correctAns = question.answer; // The correct answer is stored in `answer`
    _selectedAns = selectedIndex; // The selected answer index

    // Check if the selected answer is correct
    if (_correctAns == _selectedAns) {
      _numOfCorrectAns++; // Increment the correct answer count if the answer is correct

      // Store the score in Firestore
      FirebaseFirestore.instance
          .collection(qName)
          .doc(CacheHelper.get(key: 'uid'))
          .set({
        'correctAnswer': _numOfCorrectAns,
        'name': CacheHelper.get(key: 'name')
      });
    }

    // Get the ranking after checking the answer
    getRank(qName);

    // Stop the timer animation once the answer is selected
    _animationController!.stop();
    update();

    // Navigate to the next screen after a short delay (3 seconds)
    Future.delayed(Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber != options.length) {
      _isAnswered = false; // Reset the answer status for the next question

      // Move to the next page (question)
      _pageController!
          .nextPage(duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the timer animation for the next question
      _animationController!.reset();
      _animationController!.forward().whenComplete(nextQuestion);
    } else {
      // All questions have been answered, navigate to the results screen
      if (numOfCorrectAns >= options.length) {
        Get.offAll(AfterGameScreen(score: numOfCorrectAns));
      } else {
        Get.offAll(AfterGameScreen(score: numOfCorrectAns));
      }
    }
  }


  void updateTheQnNum(int index) {
    _questionNumber = index + 1;
  }
}
