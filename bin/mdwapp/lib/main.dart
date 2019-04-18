import 'package:flutter/material.dart';
import 'package:mdwapp/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.amber,
          accentColor: Colors.black
      ),
      home:RootPage(),
    );
  }
}
