import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/auth_services.dart';
import 'package:todo_app/login.dart';
import 'package:todo_app/signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter Demo Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Text("This is Home Page", style: TextStyle(fontSize: 20)),
              ),
              Center(
              //   show the current logged in user email
                child: Text("Current User: ${FirebaseAuth.instance.currentUser!.email}", style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                print("Button is pressed");
                FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                var sharedPref = await SharedPreferences.getInstance();
                sharedPref.setBool('login', false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                }, child: Text("LogOut"))
            ],
          ),
        ],
      ),
    );
  }
}