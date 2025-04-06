import 'dart:convert';
import 'package:flutter_new_application/config/config.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<dynamic>> fetchNews({String category = 'general'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?category=$category&apiKey=${AppConfig.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
