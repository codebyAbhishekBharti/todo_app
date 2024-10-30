import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  bool description_field_enabler = false;
  bool star_icon_enabler = false;
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
                                    setState(() {
                                      selectedTask="Starred";
                                    });
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black87.withAlpha(180),
                            borderRadius: BorderRadius.circular(15),
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Align(
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userEmail)
                                        .collection(selectedTask ?? 'My Tasks')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      }

                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return Center(
                                          child: Text(
                                            'No tasks available',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }

                                      final tasks = snapshot.data!.docs;
                                      return Column(
                                        children: tasks.map((task) {
                                          return ListTile(
                                            title: Text(
                                              task['title'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              task['description'],
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () async {
                                                // Delete the specific task from Firebase
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(userEmail)
                                                    .collection(selectedTask ?? 'My Tasks')
                                                    .doc(task.id) // Use the document ID to reference the task
                                                    .delete()
                                                    .then((_) {
                                                  print("Task successfully deleted!");
                                                }).catchError((error) {
                                                  print("Failed to delete task: $error");
                                                });
                                              },
                                                icon: Icon(Icons.delete, color: Colors.white.withAlpha(100)),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController ttitle = TextEditingController();
          TextEditingController description = TextEditingController();
          TextEditingController date = TextEditingController();
          date.text = "2000-01-01 00:00:00";
          bool favoriate = false;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // To allow the sheet to resize with the keyboard
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            backgroundColor: Colors.grey[900],
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 15.0,
                      // Adjust bottom padding for the keyboard
                      bottom: MediaQuery.of(context).viewInsets.bottom + 15.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Set size to minimum required
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: ttitle,
                            decoration: InputDecoration(
                              hintText: 'New task',
                              hintStyle: TextStyle(color: Colors.white.withAlpha(150)),
                              border: InputBorder.none, // Remove the border
                            ),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400), // Set text color to white
                          ),
                          if (description_field_enabler)
                            Container(
                              height: 25,
                              child: TextField(
                                controller: description,
                                decoration: InputDecoration(
                                  hintText: 'Add Details',
                                  hintStyle: TextStyle(color: Colors.white.withAlpha(150)),
                                  border: InputBorder.none, // Remove the border
                                ),
                                style: TextStyle(color: Colors.white, fontSize: 14), // Set text color to white
                              ),
                            ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    description_field_enabler = !description_field_enabler;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(Icons.menu, color: Colors.white.withAlpha(200)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2099),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                            surface: Colors.grey.shade900,
                                            onSurface: Colors.white,
                                          ),
                                          dialogBackgroundColor: Colors.grey[900]!.withAlpha(180),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                      final DateTime finalDateTime = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                      );
                                      setModalState(() {
                                        date.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(finalDateTime);
                                      });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(Icons.watch_later_outlined, color: Colors.white.withAlpha(200)),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  favoriate = !favoriate;
                                  setModalState(() {
                                    star_icon_enabler = !star_icon_enabler;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon((star_icon_enabler)?Icons.star:Icons.star_border_outlined, color: Colors.white.withAlpha(200)),
                                ),
                              ),
                              Spacer(), // This will push the following Done to the right
                              GestureDetector(
                                onTap: () async{
                                  print(ttitle.text);
                                  print(description.text);
                                  print(favoriate);
                                  print(date.text);
                                  bool task_added = await taskHandler.add_task(selectedTask ?? 'My Tasks', ttitle.text, description.text, favoriate, date.text);
                                  if(task_added==true){
                                    setModalState(() {
                                      star_icon_enabler = false;
                                      description_field_enabler = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                  else{
                                    print("Error adding task");
                                  }
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
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