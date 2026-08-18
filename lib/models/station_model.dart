class StationModel {
  const StationModel({required this.id, required this.name, required this.city, required this.state});
  final String id;
  final String name;
  final String city;
  final String state;
  String get location => '$city/$state';
}
