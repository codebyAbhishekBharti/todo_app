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
  String? selectedTask; // Variable to keep track of the selected task

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 28, 30),
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: kToolbarHeight,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 25, 28, 30),
        child: Container(
          margin: EdgeInsets.only(top: 15),
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
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Star button pressed");
                                    print(selectedTask);
                                    selectedTask="fav";
                                    print(selectedTask);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
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
                                          '', // No tasks available
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }

                                    final taskList = snapshot.data!.data()?['tasks'];
                                    if (taskList == null || taskList.isEmpty) {
                                      return Center(
                                        child: Text(
                                          '', // No tasks available
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: taskList.map<Widget>((task) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTask = task; // Update selected task
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 15, right: 15),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    task.toString(),
                                                    style: TextStyle(
                                                      color: selectedTask == task
                                                          ? Color.fromRGBO(26, 115, 232, 1)
                                                          : Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  // Conditionally render the Container only if the task is selected
                                                  if (selectedTask == task)
                                                    Container(
                                                      width: 60,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(26, 115, 232, 1), // Blue color when selected
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(10),
                                                          topRight: Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                ],
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NewList()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      "+ New list",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
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
      ),
    );
  }
}
