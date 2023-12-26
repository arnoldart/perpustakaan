import 'package:flutter/material.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:provider/provider.dart';

class SettingUserPage extends StatelessWidget {
  const SettingUserPage({super.key});

  void _logout(BuildContext context) {
    Provider.of<AuthModel>(context, listen: false).isLoggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<AuthModel>(context).isLoggedIn;

    // Melakukan pengecekan status login
    if (!isLoggedIn) {
      // Jika belum login, kembali ke halaman login
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/auth');
      });
    }

    return Scaffold(
      body: Center(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            child: const Text("Logout"),
          ),
        ),
      ),
    );
  }
}