import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travelblog/HomePage.dart';
import 'package:travelblog/Mapping.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    required this.auth,
    required this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          // dialogBox.information(context, "", "Logged in succesfully.");
          final userId = await widget.auth.SignIn(_email, _password);
          // print("login userId = " + userId);
        } else {
          dialogBox.information(context, "Congratulations", "Your account has been created succesfully.");
          final userId = await widget.auth.SignUp(_email, _password);
          // print("Register userId = " + userId);
        }

        widget.onSignedIn();
      } catch (e) {
        // dialogBox.information(context, "Error = ", e.toString());
        print("Error = " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState!.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Travel Blog app"),
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value!.isEmpty ? 'Email is required.' : null;
        },
        onSaved: (value) {
          _email = value!;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value!.isEmpty ? 'Password is required.' : null;
        },
        onSaved: (value) {
          _password = value!;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/app_logo.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new ElevatedButton(
          child: new Text("login", style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new TextButton(
          child: new Text("Not have an account? Create Account?",
              style: new TextStyle(fontSize: 14.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new ElevatedButton(
          child:
              new Text("Create Account.", style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new TextButton(
          child: new Text("Already have an account? Login",
              style: new TextStyle(fontSize: 14.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
