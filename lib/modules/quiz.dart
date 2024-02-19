import 'question.dart';
import 'tour.dart';

class Quiz {
  int id;
  List<Question> questions;
  Tour tour;

  Quiz(this.id, this.questions, this.tour);
}