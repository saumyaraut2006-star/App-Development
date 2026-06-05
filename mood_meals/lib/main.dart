import 'package:flutter/material.dart';
import 'home_screen.dart';
void main() {
  runApp(MoodMealsApp());
}
class MoodMealsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Meals',
      home: HomeScreen(),
    );
  }}

