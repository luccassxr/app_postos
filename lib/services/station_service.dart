import '../models/station_model.dart';

class StationService {
  static const stations = <StationModel>[
    StationModel(id: 'ceres', name: 'Posto WK Ceres', city: 'Ceres', state: 'GO'),
    StationModel(id: 'jaragua', name: 'Posto WK Jaraguá', city: 'Jaraguá', state: 'GO'),
    StationModel(id: 'anapolis', name: 'Posto WK Anápolis', city: 'Anápolis', state: 'GO'),
    StationModel(id: 'rio-verde', name: 'Posto WK Rio Verde', city: 'Rio Verde', state: 'GO'),
    StationModel(id: 'jatai', name: 'Posto WK Jataí', city: 'Jataí', state: 'GO'),
    StationModel(id: 'querencia', name: 'Posto WK Querência', city: 'Querência', state: 'MT'),
  ];

  List<StationModel> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return stations;
    return stations.where((station) => '${station.name} ${station.city} ${station.state}'.toLowerCase().contains(normalized)).toList();
  }
}
