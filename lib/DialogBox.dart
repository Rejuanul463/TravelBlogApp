import 'package:flutter/material.dart';

class DialogBox{
  information(BuildContext context, String title, String description){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return  AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description)
                ]
              ),
            ),

            actions: [
              TextButton(
                  onPressed: (){
                    return Navigator.pop(context);
                  },
                  child: Text('ok')
              )
            ],
          );
        }
    );
  }
}