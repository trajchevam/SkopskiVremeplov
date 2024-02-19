import 'monument.dart';

class Question {
  int id;
  String question;
  List<String> options;
  String correctAnswer;
  Monument monument;

  Question(this.id, this.question, this.options, this.correctAnswer, this.monument);
}