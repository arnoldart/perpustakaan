import 'package:flutter/material.dart';

class LokasiUser extends StatelessWidget {
  const LokasiUser({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard_user');
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Lokasi', style: TextStyle(color: Colors.white)),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/dashboard_user');
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF5271FF),
          ),
          body: InteractiveViewer(
              maxScale: 5.0,
              minScale: 0.05,
              constrained: false,
              child: Image.asset('img/mapimage.png'))),
    );
  }
}
