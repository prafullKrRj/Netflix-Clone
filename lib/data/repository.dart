import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/movie.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository();
});
final currentMovieProvider = StateProvider<Movie?>((ref) => null);

class UserRepository {
  Future<List<Movie>> getAllMovies() async {
    try {
      const url = "https://api.tvmaze.com/search/shows?q=all";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final url = "https://api.tvmaze.com/search/shows?q=$query";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
