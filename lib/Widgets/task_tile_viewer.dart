import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget taskContainer({
  required String label,
  required Color labelColor,
  required String userEmail,
  required String? selectedTask,
  required Stream<QuerySnapshot> stream,
  bool showDateHeader = false,
}) {
  return Container(
    child: StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Waiting for data...");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox.shrink();
        }

        final tasks = snapshot.data!.docs;
        return Column(
          children: [
            if(showDateHeader==false)
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(label, style: TextStyle(color: labelColor)),
              ),
            ),
            Column(
              children: tasks.map((task) {
                String? formattedDate;

                // Display date header if enabled
                if (showDateHeader) {
                  DateTime dateTime = (task['task_date'] as Timestamp).toDate();
                  formattedDate = DateFormat('EEE, d MMM').format(dateTime);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader && formattedDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          int newStatus = task['status'] == 0 ? 1 : 0;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userEmail)
                              .collection(selectedTask ?? 'My Tasks')
                              .doc(task.id)
                              .update({'status': newStatus})
                              .then((_) => print("Task status updated successfully!"))
                              .catchError((error) => print("Failed to update task status: $error"));
                        },
                        icon: Icon(
                          task['status'] == 1 ? Icons.check_circle : Icons.circle_outlined,
                          color: task['status'] == 1 ? Colors.green : Colors.white,
                        ),
                      ),
                      title: Text(task['title'], style: TextStyle(color: Colors.white)),
                      subtitle: task['description'] != null && task['description'].isNotEmpty
                          ? Text(task['description'],style: TextStyle(color: Colors.grey),) : null,
                      trailing: IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userEmail)
                              .collection(selectedTask ?? 'My Tasks')
                              .doc(task.id)
                              .delete()
                              .then((_) => print("Task successfully deleted!"))
                              .catchError((error) => print("Failed to delete task: $error"));
                        },
                        icon: Icon(Icons.delete, color: Colors.white.withAlpha(100)),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
  );
}
