class LocationModel {
  final int? id;
  final double? latitude;
  final double? longitude;
  final DateTime? timestamp;

  LocationModel({this.id, this.latitude, this.longitude, this.timestamp});

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp:
          map['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  bool get hasValidCoordinates => latitude != null && longitude != null;

  @override
  String toString() {
    return 'Lat: $latitude, Lng: $longitude, Time: $timestamp';
  }
}
