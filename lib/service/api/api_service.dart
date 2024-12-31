import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/country.dart';

class ApiService {
  final client = http.Client();

  Future<List<Country>> countryData() async {
    try {
      final response = await client.get(Uri.parse('https://restcountries.com/v3.1/all'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((countryJson) => Country.fromJson(countryJson)).toList();
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      throw Exception('Unable to fetch countries: $e');
    }
  }
}
