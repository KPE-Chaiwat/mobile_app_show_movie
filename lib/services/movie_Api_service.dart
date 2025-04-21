import 'package:dio/dio.dart';

import '../models/movie_model.dart';

class MovieApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://whoa.onrender.com/whoas/random?results=20';

  Future<List<Movie>> getRandomMovies() async {
    try {
      final response = await _dio.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Map String response to Model
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
