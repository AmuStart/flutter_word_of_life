import 'package:flutter/material.dart';
import 'pages/bible_home_page.dart';


class BibleApp extends StatelessWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BibleHomePage(),
    );
  }
}