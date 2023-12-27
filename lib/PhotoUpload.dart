import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelblog/Mapping.dart';
import 'dart:io';
import 'HomePage.dart';
import 'package:travelblog/HomePage.dart';


class UploadPhotoPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final ImagePicker picker = ImagePicker();
  File? sampleImage;
  String? _myValue;
  String? url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    final tempImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = File(tempImage!.path);
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void uploadStatusImage() async {
    if(validateAndSave()){
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("image" + DateTime.now().toString() + ".jpg");

      UploadTask uploadTask = ref.putFile(sampleImage!);
      String imageUrl = "";
      uploadTask.whenComplete(() {
        imageUrl = ref.getDownloadURL() as String;
      }).catchError((onError){
        print(onError.toString());
      });

      url = imageUrl;
      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url){
    var dbTimeKey = new DateTime.now();
    var formateDate = new DateFormat('MMM d, yyyy');
    var formateTime = new DateFormat('EEE, hh:mm:aaa');

    String date = formateDate.format(dbTimeKey);
    String time = formateTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.ref();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time":time,
    };

    ref.child("posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Image"),
        centerTitle: true,
      ),

      body: new Center(
        child: sampleImage == null? Text("Select an Image"): enableUpload(),
      ),

      floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: new Form(
        key: formKey,
        child: Column(
            children: <Widget>[
              Image.file(sampleImage!, height: 330.0, width: 600.0,),

              SizedBox(height: 15.0,),

              TextFormField(
                decoration: new InputDecoration(labelText: 'Description'),

                validator: (value) {
                  return value!.isEmpty? 'Description is required' : null;
                },
                onSaved: (value){
                  _myValue = value!;//may need to return..................
                },
              ),
              SizedBox(height: 15.0,),
              
              ElevatedButton(
                onPressed: uploadStatusImage,
                child: Text("add a new Post"),

              ),
            ]
        ),
      ),
    );
  }
}

