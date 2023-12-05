import 'package:flutter/material.dart';
import 'api_service.dart';
import 'post.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API Demo',
      home: PostList(),
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post List'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(posts[index].title),
                    subtitle: Text(posts[index].body),
                    onTap: () {
                      _navigateToPostDetail(posts[index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetail(post),
      ),
    );
  }
}

class PostDetail extends StatelessWidget {
  final Post _post;
  

  PostDetail(this._post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2.0,
            margin: EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(_post.title),
              subtitle: Text(_post.body),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  updatePost(_post);
                  Navigator.pop(context, true);
                },
                child: Text('Update'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  deletepost(_post.id);
                  Navigator.pop(context, true);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}