import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'PhotoUpload.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.auth,
    required this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];
  final dbRef = FirebaseDatabase.instance.ref().child("posts");
  //////////////////////////////////////////////////////////////////
  @override
  void initState() {
    // super.initState();
    // DatabaseReference postRef = FirebaseDatabase.instance.ref().child("posts");
    //
    // postRef.once().then((DataSnapshot snap) {
    //   var KEYS = snap.key;
    //   var DATA = snap.value;
    //
    //   postsList.clear();
    //   for(var individualKey in KEYS){
    //     Posts posts = new Posts(
    //       DATA[individualKey]['image'],
    //       DATA[individualKey]['description'],
    //       DATA[individualKey]['date'],
    //       DATA[individualKey]['time'],
    //     );
    //
    //     postsList.add(posts);
    //   }
    //   setState(() {
    //     print('Length: $postsList.length');
    //   });
    // } as FutureOr Function(DatabaseEvent value));
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("home");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home"),
        ),
        body: new Container(
          child: postsList.length == 0 ? new Text("No Blog Post Available!") :
          new ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (_, index){
              return PostsUI(postsList[index].image,
                              postsList[index].description,
                              postsList[index].date,
                              postsList[index].time,);
            },
          ),
        ),
        bottomNavigationBar: new BottomAppBar(
          color: Colors.purple,
          child: new Container(
            margin: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new IconButton(
                  onPressed: _logoutUser,
                  icon: new Icon(Icons.local_car_wash),
                  iconSize: 50,
                  color: Colors.white,
                ),
                new IconButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return UploadPhotoPage();
                        })
                    );
                  },
                  icon: new Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ));
  }

  Widget PostsUI(String image , String description, String date , String time){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(25.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(height: 10.0,),

            new Image.network(image , fit : BoxFit.cover),

            SizedBox(height: 10.0,),
            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

}

