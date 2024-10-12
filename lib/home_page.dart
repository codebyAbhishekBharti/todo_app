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
                      width: 35,
                      height: 35,
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
                  // width: MediaQuery.of(context).size.width*0.7,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 0, right: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // make star icon
                      Container(margin: EdgeInsets.only(left: 20, right: 20),child: Icon(Icons.star, color: Colors.white , size: 25)),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.only(left: 20, right: 20),
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
                      Container(margin: EdgeInsets.only(left: 20, right: 20),child: Text("+ New Task", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))),
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
            Container(
                width: MediaQuery.of(context).size.width*0.9,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
            ),
          ],
        ),
      ),
    );
  }
}