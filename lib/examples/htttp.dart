import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../widgets/index.dart';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    // The advantages of this approach is that. the app shell,
    // serves like a container that can be used as a resuable widget
    // The page routed to first automatically sets the dynamic variables needed by the app bar

    // Now this approach only works when there is a flat structure. Now nested structures
    // might want to update the app bar and now they can't

    // what if even while on a page i want to chage the app bar dynamically
    // use the browser title for that
    return AppShell(
      title: 'Home Screen',
      // options: [],
      bodyContent: Center(
        child: FutureBuilder(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? photoList(snapshot.data)
                : CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget photoList(List<Photo> photos) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: photos.length,
      itemBuilder: (_, i) {
        return Image.network(photos[i].thumbnailUrl);
      },
    );
  }

  Future<Post> fetchData() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falied to load post');
    }
  }

  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response =
        await client.get('https://jsonplaceholder.typicode.com/photos');

    if (response.statusCode == 200) {
      // now compute only works when the method lives outside the class
      return compute(parsePhotos, response.body);
    } else {
      throw Exception('Falied to load photos');
    }
  }
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}
