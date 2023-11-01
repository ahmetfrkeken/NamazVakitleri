import 'dart:convert';
import 'package:http/http.dart' as http;
import '../namaz_vakti_data.dart';

class ApiService {
  final String _baseUrl = 'namaz-vakti.vercel.app';
  final String _namazVaktiEP = '/api/timesFromPlace';

  static final ApiService _instance = ApiService._privateConstructor();

  ApiService._privateConstructor();

  factory ApiService() {
    return _instance;
  }

  Future<NamazVakti> fetchNamazVakti(Map<String, dynamic> params) async {
    var url = Uri.https(_baseUrl, _namazVaktiEP, params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return NamazVakti.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load Namaz Vakitleri');
    }
  }
}
