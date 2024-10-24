import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskHandler {
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Function to delete a task from the 'tasks' array field of a user document
  Future<bool> deleteTask(String? taskName) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userEmail);
      await userDoc.update({
        'tasks': FieldValue.arrayRemove([taskName]),
      });
      print('Task deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  void getTasks() async{
    // Get the user document reference
    final userDoc = await _firestore.collection('users').doc(userEmail).collection("My Tasks");
    userDoc.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["title"]);
        print(doc['description']);
      });
    });
  }
}
