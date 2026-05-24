import 'package:flutter/material.dart';

void main() {
  runApp(MyScreen());
}

class MyScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context){

    return MaterialApp(

      home: Scaffold(

        appBar: AppBar(titla: Text("Foodie😋")),

        body: Center(
          child: Text("Hello Guys!, Welcome to Flutter"),
        )

      ),



    );
  }
}