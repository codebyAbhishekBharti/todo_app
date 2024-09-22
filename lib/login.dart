import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/signup.dart';
import 'auth_services.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  void dispose() {
    super.dispose();
    emailText.dispose();
    passText.dispose();
  }
  var emailText = TextEditingController();
  var passText = TextEditingController();
  void _signIn() async {
    String email = emailText.text;
    String pass = passText.text;

    var sharedPref = await SharedPreferences.getInstance();

    User? user = await _auth.signInWithEmailAndPassword(email, pass);
    if (user != null) {
      print("User is created");
      sharedPref.setBool('login', true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      print("Some error happened");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  labelText: 'Enter your username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  labelText: 'Enter your password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Email: ${emailText.text}');
                  print('Password: ${passText.text}');
                  _signIn();
                },
                child: const Text('Login'),
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup_page()),
                );
              }, child: Text("SignUp"))
            ],
          ),
        ),
      )
    );
  }
}