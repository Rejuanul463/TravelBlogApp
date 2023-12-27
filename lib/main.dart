import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Travel Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
