class Direction {
  final String destinationAddress;
  final String originAddress;
  final String totalDistance;
  final String totalDuration;
  final int distanceValue;
  final int durationValue;

  Direction({
    required this.destinationAddress,
    required this.originAddress,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory Direction.fromMap(Map<String, dynamic> map) {
    // JSON yapısına göre destination_addresses ve origin_addresses birer liste
    final destinationAddress = (map['destination_addresses'] as List).isNotEmpty
        ? map['destination_addresses'][0]
        : '';
    final originAddress = (map['origin_addresses'] as List).isNotEmpty
        ? map['origin_addresses'][0]
        : '';

    // rows ve elements yapısını parse etme
    if ((map['rows'] as List).isEmpty) {
      throw Exception("No rows found");
    }

    final row = map['rows'][0];
    if ((row['elements'] as List).isEmpty) {
      throw Exception("No elements found");
    }

    final element = row['elements'][0];
    if (element['status'] != 'OK') {
      throw Exception("Element status is not OK");
    }

    final distance = element['distance']['text'];
    final duration = element['duration']['text'];
    final distanceValue = element['distance']['value'];
    final durationValue = element['duration']['value'];

    return Direction(
      destinationAddress: destinationAddress,
      originAddress: originAddress,
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue,
    );
  }
}