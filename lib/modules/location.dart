class Location {
  final String locationName;
  final double latitude;
  final double longitude;

  Location(
      {required this.locationName, required this.latitude, required this.longitude});

  static List<Location> getLocations() {
    return [
      Location(locationName: "Камен мост", latitude: 41.9972148, longitude: 21.4333684),
      Location(locationName: "Кале", latitude: 42.0004727, longitude: 21.4301849),
      Location(locationName: "Стара чаршија", latitude: 42.0004011, longitude: 21.4330516),
      Location(locationName: "Плоштад Македонија", latitude: 41.995936, longitude: 21.4288761),
      Location(locationName: "Градски парк", latitude: 42.0075999, longitude: 21.4110848),
      Location(locationName: "Матка", latitude: 41.9522628, longitude: 21.2598093),
      Location(locationName: "Милениумски крст", latitude: 41.9651424, longitude: 21.3917756),
    ];
  }

  static Location location1 = Location.getLocations()[0];
  static Location location2 = Location.getLocations()[1];
  static Location location3 = Location.getLocations()[2];
  static Location location4 = Location.getLocations()[3];
  static Location location5 = Location.getLocations()[4];
  static Location location6 = Location.getLocations()[5];
  static Location location7 = Location.getLocations()[6];
}