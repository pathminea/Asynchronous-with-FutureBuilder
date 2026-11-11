import 'package:flutter/material.dart';
import 'package:flutter_application_1/post.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

Future<String> someFutureFunction() {
  Future<String> data = Future.delayed(
    Duration(seconds: 4),
    () => "News is loaded ...",
  );
  return data;
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Post.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScrean());
  }
}

class HomeScrean extends StatefulWidget {
  const HomeScrean({super.key});

  @override
  State<HomeScrean> createState() => HomeScreanState();
}

class HomeScreanState extends State<HomeScrean> {
  late final Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData && !snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) => ListTile(title: Text(users[i].name)),
          );
        },
      ),
    );
  }
}
class User {
  final String name;
  final String username;
  final String email;

  const User({required this.name, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
      );
}
Future<List<User>> getUserData() async {
  final response = await http.get(
    Uri.https('jsonplaceholder.typicode.com', 'users'),
  );
  if (response.statusCode == 200) {
    final list = jsonDecode(response.body) as List;
    return list.map((data) => User.fromJson(data)).toList();
  } else {
    // The server did not return 200 OK → throw an exception
    throw Exception('Failed to load users');
  }
}



class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    // Cache the fetch call in initState so it doesn't refetch on every rebuild
    futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API List Example')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
    );
  }
}
