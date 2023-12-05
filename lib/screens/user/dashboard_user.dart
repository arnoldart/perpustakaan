import 'package:flutter/material.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DashboardUser extends StatelessWidget {
  const DashboardUser({super.key});

  void _logout(BuildContext context) {
    // Ubah status login menjadi false menggunakan Provider
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
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Panggil fungsi logout
              Navigator.pushReplacementNamed(context, '/setting_user');
            },
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        'assets/sample.pdf',
      ),
    );
  }
}