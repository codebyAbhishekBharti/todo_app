import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/profile.dart';

import 'new_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
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
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(left: 0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                  icon: Icon(Icons.star, color: Colors.white, size: 24),
                                  onPressed: () {
                                    // Handle button press
                                    print("Star button pressed");
                                    print(userEmail);
                                  },
                                ),
                              ),
                              // Subtasks from the Firestore StreamBuilder
                              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userEmail)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  if (!snapshot.hasData || !snapshot.data!.exists) {
                                    return Center(
                                      child: Text(
                                        '', //no tasks available
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }

                                  // Access the task field which is an array of task names
                                  final taskList = snapshot.data!.data()?['tasks'];
                                  if (taskList == null || taskList.isEmpty) {
                                    return Center(
                                      child: Text(
                                        '', //No tasks available.
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }

                                  // Display tasks as a horizontal row
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: taskList.map<Widget>((task) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15),
                                          child: Text(
                                            task.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NewList()), // Navigate to ProfilePage
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      "+ New list",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
