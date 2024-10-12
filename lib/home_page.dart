import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/auth_services.dart';
import 'package:todo_app/login.dart';
import 'package:todo_app/profile.dart';
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
        backgroundColor: Color.fromARGB(255, 22, 25, 22),
        automaticallyImplyLeading: false, // This removes the back button
        title: SizedBox(
          height: kToolbarHeight, // This ensures the height matches the AppBar's height
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Tasks',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/profile_image.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  onPressed: () {
                    print("Profile button is pressed");
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 22, 25, 22),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  // margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // make star icon
                      Icon(Icons.star, color: Colors.white , size: 25),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 4.0, color: Color.fromARGB(255, 37, 150, 190),),
                          ),
                        ),
                        child: Text("My Tasks",
                            style: TextStyle(
                                color: Color.fromARGB(255, 37, 150, 190),
                                fontSize: 15, fontWeight: FontWeight.bold)
                        ),
                      ),
                      Text("+ New Task", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            Container(
              color: Colors.white, // Set the color of the SizedBox
              child: SizedBox(
                width: double.infinity,
                height: 1, // Height of the SizedBox
              ),
            ),
            Container(width: double.infinity,child: Text("hello`", style: TextStyle(color: Colors.white),),
                ),
          ],
        ),
      ),
    );
  }
}