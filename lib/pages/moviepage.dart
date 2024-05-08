// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late Future<List<Movie>> _moviesFuture;
  late List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://imdb-top-100-movies.p.rapidapi.com'),
        headers: {
          'x-rapidapi-host': 'imdb-top-100-movies.p.rapidapi.com',
          'x-rapidapi-key':
              '2d04a639f1mshbe9c8d2ac8b49e5p1f4ea3jsna2973b846f27',
          'useQueryString': 'true',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<Movie> movies =
            responseData.map((json) => Movie.fromJson(json)).toList();
        return movies;
      } else {
        throw Exception(
            'API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching movies data: $e');
      throw Exception('Failed to load movies data: $e');
    }
  }

  void deleteMovie(int index) {
    setState(() {
      _movies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Movies',
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<List<Movie>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                _movies = snapshot.data!;
                return ListView.builder(
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    Movie movie = _movies[index];
                    return Dismissible(
                      key: Key(movie.title),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteMovie(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.deepPurple.shade400,
                          elevation: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(movie.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        movie.description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Genre: ${movie.genre.join(", ")}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Rating: ${movie.rating.toStringAsFixed(1)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text('No movies available',
                    style: TextStyle(color: Colors.white));
              }
            },
          ),
        ),
      ),
    );
  }
}
