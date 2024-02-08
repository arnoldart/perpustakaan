import 'package:flutter/material.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:provider/provider.dart';

class SettingAdminPage extends StatefulWidget {
  const SettingAdminPage({super.key});

  @override
  State<SettingAdminPage> createState() => _SettingAdminPageState();
}

class _SettingAdminPageState extends State<SettingAdminPage> {
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
      appBar: AppBar(
        leading: (
          IconButton(
            onPressed: () { Navigator.pushReplacementNamed(context, '/dashboard_admin'); }, 
            icon: const Icon(Icons.arrow_back_ios)
          )
        ),
      ),
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