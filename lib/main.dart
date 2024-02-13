import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:perpustakaan/screens/admin/dashboard_admin.dart';
import 'package:perpustakaan/screens/admin/list_buku_admin.dart';
import 'package:perpustakaan/screens/admin/lokasi_admin.dart';
import 'package:perpustakaan/screens/admin/setting_admin.dart';
import 'package:perpustakaan/screens/admin/tambah_siswa.dart';
import 'package:perpustakaan/screens/admin/upload_admin.dart';
import 'package:perpustakaan/screens/auth_page.dart';
import 'package:perpustakaan/screens/onBoarding/on_Boarding.dart';
import 'package:perpustakaan/screens/user/dashboard_user.dart';
import 'package:perpustakaan/screens/user/list_buku_user.dart';
import 'package:perpustakaan/screens/user/lokasi_user.dart';
import 'package:perpustakaan/screens/user/setting_admin.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const OnBoarding(),
        routes: {
          '/on_boarding': (context) => const OnBoarding(),
          '/auth': (context) => AuthPage(),
          // ADMIN
          '/dashboard_admin': (context) => const DashboardAdmin(),
          '/setting_admin': (context) => const SettingAdminPage(),
          '/upload_admin': (context) => const UploadPageAdmin(),
          '/tambah_siswa': (context) => const TambahSiswa(),
          '/lokasi_admin': (context) => const LokasiAdmin(),
          '/list_buku_admin': (context) => const ListBukuAdmin(),
          // USER
          '/dashboard_user': (context) => const DashboardUser(),
          '/setting_user': (context) => const SettingUserPage(),
          '/list_buku_user': (context) => const ListBukuUser(),
          '/lokasi_user': (context) => const LokasiUser(),
        },
      ),
    );
  }
}
