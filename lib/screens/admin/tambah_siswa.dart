import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perpustakaan/components/upload_text_field.dart';
import 'package:path_provider/path_provider.dart';

class TambahSiswa extends StatefulWidget {
  const TambahSiswa({super.key});

  @override
  State<TambahSiswa> createState() => _TambahSiswaState();
}

class _TambahSiswaState extends State<TambahSiswa> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isUsernameEmpty = false;
  bool isPasswordEmpty = false;

  @override
  void initState() {
    super.initState();
    // _checkAndRequestPermission();
  }

  Future<String> copyFileToExternalStorage(
      String cacheFilePath, String folderName) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String perpustakaanDirPath = '${externalDir!.path}/$folderName';

      // Buat folder perpustakaan jika belum ada
      Directory(perpustakaanDirPath).createSync(recursive: true);

      File cacheFile = File(cacheFilePath);
      String destinationPath =
          '$perpustakaanDirPath/${cacheFile.uri.pathSegments.last}';

      await cacheFile.copy(destinationPath);

      return destinationPath;
    } catch (e) {
      // ignore: avoid_print
      print('Error copying file: $e');
      return '';
    }
  }

  Future<void> _uploadFile() async {
    if (_validateForm()) {
      // Implementasi upload file ke server atau aksi lainnya
      await addToBookJson();
      setState(() {
        username.text = '';
        password.text = '';
      });

      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard_admin', (route) => false);
    }
  }

  bool _validateForm() {
    setState(() {
      isUsernameEmpty = username.text.isEmpty;
      isPasswordEmpty = password.text.isEmpty;
    });

    if (isPasswordEmpty || isPasswordEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addToBookJson() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String bookJsonPath = '${externalDir!.path}/user.json';

      List<dynamic> jsonData = [];
      int newId = 1; // ID awal

      if (File(bookJsonPath).existsSync()) {
        // Baca data saat ini dari user.json
        String jsonDataString = await File(bookJsonPath).readAsString();
        jsonData = json.decode(jsonDataString);

        // Ambil ID terbesar yang ada
        if (jsonData.isNotEmpty) {
          List<int> ids =
              jsonData.map((entry) => entry['id']).cast<int>().toList();
          newId = ids.reduce(
                  (value, element) => value > element ? value : element) +
              1;
        }
      }

      // Tambahkan data pengguna baru dengan ID yang baru dihasilkan
      jsonData.add({
        'id': newId,
        'username': username.text,
        'password': password.text,
        'role': 'user',
      });

      // Simpan kembali ke dalam user.json
      await File(bookJsonPath).writeAsString(json.encode(jsonData));
    } catch (e) {
      // ignore: avoid_print
      print('Error adding to user.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard_admin');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title:
              const Text('Tambah Siswa', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard_admin');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF5271FF),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // Tambahkan widget SingleChildScrollView di sini
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: username,
                    hintText: "Masukkan Nama Siswa",
                    obscureText: false,
                    errorText:
                        isPasswordEmpty ? "Harap masukkan ID siswa" : null,
                  ),
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: password,
                    hintText: "Masukkan Password",
                    obscureText: false,
                    errorText:
                        isUsernameEmpty ? "Harap masukkan password" : null,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _uploadFile();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFF3131),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Tambah",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
