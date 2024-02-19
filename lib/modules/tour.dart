import 'package:skopski_vremeplov/modules/monument.dart';

class Tour {
  int id;
  String name;
  int daysNeeded;
  List<Monument> monuments;

  Tour(this.id, this.name, this.daysNeeded, this.monuments);
}