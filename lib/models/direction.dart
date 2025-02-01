class Direction {
  final String startAddress;
  final String endAddress;
  final String totalDistance;
  final String totalDuration;
  final int distanceValue;
  final int durationValue;

  Direction({
    required this.startAddress,
    required this.endAddress,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory Direction.fromMap(Map<String, dynamic> map) {
    // routes listesinin boş olup olmadığını kontrol et
    if ((map['routes'] as List).isEmpty) {
      throw Exception("No routes found");
    }

    // İlk route'u al
    final route = map['routes'][0];

    // legs listesinin boş olup olmadığını kontrol et
    if ((route['legs'] as List).isEmpty) {
      throw Exception("No legs found");
    }

    // İlk leg'i al
    final leg = route['legs'][0];

    // start_address ve end_address'i al
    final startAddress = leg['start_address'] ?? 'Unknown';
    final endAddress = leg['end_address'] ?? 'Unknown';

    // distance ve duration bilgilerini al
    final distance = leg['distance']['text'] ?? '0 km';
    final duration = leg['duration']['text'] ?? '0 mins';
    final distanceValue = leg['distance']['value'] ?? 0;
    final durationValue = leg['duration']['value'] ?? 0;

    return Direction(
      startAddress: startAddress,
      endAddress: endAddress,
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue,
    );
  }
}