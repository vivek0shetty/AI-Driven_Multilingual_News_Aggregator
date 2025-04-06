import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  // final String _apiKey = '1a93a4e40be2427ea942c506a3e1a571';
  // final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<dynamic>> fetchNews({String category = 'general'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
