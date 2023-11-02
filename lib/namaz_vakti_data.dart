class NamazVakti {
  final NamazVaktiPlaceData place;
  final List<NamazVaktiData> times;

  NamazVakti({required this.place, required this.times});

  factory NamazVakti.fromJson(Map<String, dynamic> json) {
    final timesJson = json['times'] as Map<String, dynamic>;
    final times = timesJson.entries.map((e) => NamazVaktiData(date: e.key, times: List<String>.from(e.value))).toList();
    return NamazVakti(place: NamazVaktiPlaceData.fromJson(json['place']), times: times);
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place.toJson(),
      'times': times.map((e) => e.toJson()).toList(),
    };
  }
}

class NamazVaktiData {
  final String date;
  final List<String> times;

  NamazVaktiData({required this.date, required this.times});

  factory NamazVaktiData.fromJson(Map<String, dynamic> json) {
    return NamazVaktiData(
      date: json['date'],
      times: json['times'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'times': times,
    };
  }
}

class NamazVaktiPlaceData {
  final String country;
  final String countryCode;
  final String city;
  final String region;
  final double latitude;
  final double longitude;

  NamazVaktiPlaceData({required this.country, required this.countryCode, required this.city, required this.region, required this.latitude, required this.longitude});

  factory NamazVaktiPlaceData.fromJson(Map<String, dynamic> json) {
    return NamazVaktiPlaceData(
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'countryCode': countryCode,
      'city': city,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
