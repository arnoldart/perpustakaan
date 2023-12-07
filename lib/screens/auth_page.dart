import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perpustakaan/components/my_text_field.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:perpustakaan/models/user_data_model.dart';
import 'package:perpustakaan/screens/user/dashboard_user.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  // Text Editing Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign User in Method
  Future<List<UserData>> fetchData() async {
    String jsonString = await rootBundle.loadString('lib/assets/data.json');
    List<dynamic> jsonList = json.decode(jsonString);

    List<UserData> userList = jsonList.map((json) => UserData.fromJson(json)).toList();

    return userList;
  }

  void signInUser(BuildContext context) async {
    List<UserData> userList = await fetchData();

    String enteredUsername = usernameController.text;
    String enteredPassword = passwordController.text;

    if(userList.any((user) =>  user.username == enteredUsername && user.password == enteredPassword && user.role == 'admin' )) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthModel>(context, listen: false).isLoggedIn = true;

      usernameController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/dashboard_admin');
    }else if(userList.any((user) =>  user.username == enteredUsername && user.password == enteredPassword && user.role == 'user' )) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthModel>(context, listen: false).isLoggedIn = true;

      usernameController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardUser()));
    }else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Gagal'),
            content: const Text('Username atau password salah.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                hintText: 'Username', 
                controller: usernameController, 
                obscureText: false,

              ),
              const SizedBox(height: 20.0,),
              MyTextField(
                hintText: 'Password', 
                controller: passwordController, 
                obscureText: false,
              ),

              const SizedBox(height: 20.0,),
              GestureDetector(
                onTap: () { signInUser(context); },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)
                    ),
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                        ),
                    ),
                  ),
                ),
              )
              // TextButton(onPressed: onPressed, child: Text('Login'))
            ],
          ),
        ),
      )
    );
  }
}


