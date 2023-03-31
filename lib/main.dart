import 'package:flutter/material.dart';
import 'package:jokee/provider/joke_provider.dart';
import 'package:jokee/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JokeProvider(),
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
