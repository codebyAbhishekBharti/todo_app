import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListPage extends StatelessWidget {
  final String title; // Page title
  final String initialText; // Initial text for the text field
  final Function(String) onDone; // Callback for when "Done" is clicked
  final Color doneButtonColor; // Color of the "Done" button
  var titleText = TextEditingController();
  TaskListPage({
    required this.title,
    required this.initialText,
    required this.onDone,
    required this.doneButtonColor,
  }) {
    titleText = TextEditingController(text: initialText);
  }
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  void saveTask() async {
    // Get the user document reference
    final userDoc = FirebaseFirestore.instance.collection('users').doc(
        userEmail);
    if (titleText.text.isNotEmpty) {
      try {
        // Check if the document exists
        DocumentSnapshot docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          // Update the tasks array by adding the new task
          await userDoc.update({
            'tasks': FieldValue.arrayUnion([titleText.text])
          });
          print("Task added successfully");
        } else {
          // If the document does not exist, you might want to create it and add the task
          await userDoc.set({
            'tasks': [titleText.text]
          });
          print("User document created and task added");
        }
      } catch (e) {
        print("Error adding task: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 25, 22),
        leading: IconButton(
          icon: Icon(
            Icons.close, // Use the close icon (cross)
            color: Color.fromARGB(200, 255, 255, 255), // Set the color to white
          ),
          onPressed: () {
            onDone(titleText.text);
            Navigator.pop(context, "done");
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(titleText.text.trim().isNotEmpty){
                saveTask();
                onDone(titleText.text);
                Navigator.pop(context, "done");
              }
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: doneButtonColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.afacad(
              textStyle: TextStyle(color: Colors.white,fontSize: 25.0,),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 22, 25, 22),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child:TextField(
                  controller: titleText,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withAlpha(200), width: 1.5), // Blue border when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withAlpha(200), width: 1.5), // Blue border when focused
                    ),
                    border: OutlineInputBorder(), // Default border when not focused
                    hintText: 'Enter list title', // Optional hint text
                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w300), // Optional hint text style
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
