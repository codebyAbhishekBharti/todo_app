import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/profile.dart';
import 'new_list.dart';
import 'package:todo_app/controller/task_handler.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  final taskHandler = TaskHandler();
  String? selectedTask = "My Tasks"; // Variable to keep track of the selected task

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
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
        color: Colors.grey[900],
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
                                    print(selectedTask);  //added this line just to check if everything is working fine
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
                                                          ? Colors.blue
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
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueAccent, // Blue color when selected
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
                                    padding: const EdgeInsets.only(bottom: 15.0, left: 15),
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - kToolbarHeight - 120,
                  decoration: BoxDecoration(
                    color: Colors.black87.withAlpha(180),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            selectedTask ?? 'No task selected',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(), // This will push the following icons to the right
                          Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10), // Optional spacing between icons
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              backgroundColor: Colors.grey[900]!.withAlpha(180),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // Set the size to the minimum needed
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'Rename list',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () {
                                          // Handle rename list action
                                          Navigator.pop(context); // Close the bottom sheet
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Delete list',
                                          style: (selectedTask=="My Tasks")?TextStyle(color: Colors.white.withAlpha(100)):TextStyle(color: Colors.white),
                                        ),
                                        // add description
                                        subtitle: (selectedTask=="My Tasks")?Text(
                                          "Default list can't be deleted",
                                          style: (selectedTask=="My Tasks")?TextStyle(color: Colors.white.withAlpha(100),fontSize: 12):TextStyle(color: Colors.white,fontSize: 12),
                                        ):null,
                                        onTap: () async {
                                          // Handle delete list action
                                          if (selectedTask != "My Tasks") {
                                            if(await taskHandler.deleteTask(selectedTask)){
                                              setState(() {
                                                selectedTask="My Tasks";
                                              });
                                              Navigator.pop(context);
                                              print("Task deleted successfully main");

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Task deleted successfully'),
                                                  duration: Duration(seconds: 2),
                                                  behavior: SnackBarBehavior.floating,
                                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                                ),
                                              );
                                            }
                                            else{
                                              print("Task deletion failed");
                                            }
                                          }
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Delete all completed tasks',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () {
                                          // Handle delete completed tasks action
                                          Navigator.pop(context); // Close the bottom sheet
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        ],
                      ),
                    ),
                  ),

                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => NewList()),
          // );
          print("add task button is pressed");
        },
        backgroundColor: Colors.blue.withAlpha(100),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
