import 'location.dart';

class Monument {
  int id;
  String name;
  Location location;
  String description;
  String img;

  Monument(this.id, this.name, this.location, this.description, this.img);

  static List<Monument> getMonuments() {
    return [
      Monument(1, "Камен мост", Location.location1, "Description", ""),
      Monument(2, "Кале", Location.location2, "", ""),
      Monument(3, "Стара чаршија", Location.location3, "", ""),
      Monument(4, "Плоштад Македонија", Location.location4, "", ""),
      Monument(5, "Градски парк", Location.location5, "", ""),
      Monument(6, "Матка", Location.location6, "", ""),
      Monument(7, "Милениумски крст", Location.location7, "", ""),
    ];
  }

  static Monument monument1 = Monument.getMonuments()[0];
  static Monument monument2 = Monument.getMonuments()[1];
  static Monument monument3 = Monument.getMonuments()[2];
  static Monument monument4 = Monument.getMonuments()[3];
  static Monument monument5 = Monument.getMonuments()[4];
  static Monument monument6 = Monument.getMonuments()[5];
  static Monument monument7 = Monument.getMonuments()[6];


  }