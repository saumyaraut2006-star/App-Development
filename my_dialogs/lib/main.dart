import 'package:flutter/material.dart';

void main() {
  runApp(DialogDemoApp());
}

//ScaffoldMessenger.of(context).showSnackBar(
  //SnackBar(
   // context: Text("Are you sure you want to undo?")
    //action: SnackBarAction(
     // label: "UNDO",
      //onPressed:(){

//
//      }
  //  )
//  )
//)
// AlertDialog( pop up box)

class DialogDemoApp extends StatelessWidget{
@override
Widget build(BuildContext context){
  return MaterialApp(
    
    home: DemoScreen(),

  );
}
}
class DemoScreen extends StatelessWidget{
@override
Widget build(BuildContext context){
  return Scaffold(

    appBar: AppBar(title: Text("Dialogs Demo")),

    body : Center(

      child: Column(
        mainAxisAlignment:  MainAxisAlignment.center, 

        children: [
//SnackBar Button
          ElevatedButton(onPressed:(){

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added to Cart!"),
              );
          }
                child: Text("Add to cart"),
          ),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed:(){
                    //Undo action
                  }
                )
              )
            );
          }),
        ],

      ),)
    );
  
}
}