import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
  Future<List<UserData>> fetchDataFromApp() async {
    String jsonString = await rootBundle.loadString('lib/assets/data.json');
    List<dynamic> jsonList = json.decode(jsonString);

    List<UserData> userList =
        jsonList.map((json) => UserData.fromJson(json)).toList();

    return userList;
  }

  Future<List<dynamic>> fetchDataUserFromInternal() async {
    try {
      List<dynamic> jsonData = await fetchUserDataFromInternal();

      List<dynamic> userList =
          jsonData.map((json) => UserData.fromJson(json)).toList();

      return userList;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
      return []; // Handle errors gracefully
    }
  }

  Future<List<dynamic>> fetchUserDataFromInternal() async {
    try {
      final file =
          File('${(await getExternalStorageDirectory())!.path}/user.json');
      if (file.existsSync()) {
        String jsonData = await file.readAsString();
        return json.decode(jsonData);
      } else {
        // Jika file belum ada, kembalikan list kosong
        return [];
      }
    } catch (e) {
      // Handle errors, seperti file tidak ditemukan
      return [];
    }
  }

  void signInUser(BuildContext context) async {
    List<UserData> userList = await fetchDataFromApp();
    List<dynamic> userInternalList = await fetchDataUserFromInternal();

    String enteredUsername = usernameController.text;
    String enteredPassword = passwordController.text;

    if (userList.any((user) =>
        user.username == enteredUsername &&
        user.password == enteredPassword &&
        user.role == 'admin')) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthModel>(context, listen: false).isLoggedIn = true;

      usernameController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/dashboard_admin');
    } else if (userList.any((user) =>
        user.username == enteredUsername &&
        user.password == enteredPassword &&
        user.role == 'user')) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthModel>(context, listen: false).isLoggedIn = true;

      usernameController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardUser()));
    } else if (userInternalList.any((user) =>
        user.username == enteredUsername &&
        user.password == enteredPassword &&
        user.role == 'user')) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthModel>(context, listen: false).isLoggedIn = true;

      usernameController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/dashboard_user');
    } else {
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
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('img/LoginBG.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'img/LogoUNP.png', // Sesuaikan dengan path gambar Anda
              height: 200, // Sesuaikan dengan tinggi gambar yang diinginkan
              width: 200, // Sesuaikan dengan lebar gambar yang diinginkan
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'SMPN 17 Kerinci',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'ErasBoldItc'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            MyTextField(
              hintText: 'Username',
              controller: usernameController,
              obscureText: false,
            ),
            const SizedBox(
              height: 20.0,
            ),
            MyTextField(
              hintText: 'Password',
              controller: passwordController,
              obscureText: false,
            ),

            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                signInUser(context);
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color(0xFFFF3131),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'ErasBoldItc'),
                  ),
                ),
              ),
            )
            // TextButton(onPressed: onPressed, child: Text('Login'))
          ],
        ),
      ),
    ));
  }
}
