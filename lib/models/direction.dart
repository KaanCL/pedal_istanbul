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

    print(map);
    if ((map['routes'] as List).isEmpty) {
      throw Exception("No routes found");
    }


    final route = map['routes'][0];

    if ((route['legs'] as List).isEmpty) {
      throw Exception("No legs found");
    }


    final leg = route['legs'][0];


    final startAddress = leg['start_address'] ?? 'Unknown';
    final endAddress = leg['end_address'] ?? 'Unknown';


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