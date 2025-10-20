import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/house.dart';

class ApiService {
  static const _baseUrl = 'https://intern.d-tt.nl/api/house';
  static const _accessKey = '98bww4ezuzfePCYFxJEWyszbUXc7dxRx';

  Future<List<House>> fetchHouses() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {"Access-Key": _accessKey},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => House.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch houses");
    }
  }
}
