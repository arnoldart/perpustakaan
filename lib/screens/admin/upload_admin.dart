import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perpustakaan/components/upload_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class UploadPageAdmin extends StatefulWidget {
  const UploadPageAdmin({super.key});

  @override
  State<UploadPageAdmin> createState() => _UploadPageAdminState();
}

class _UploadPageAdminState extends State<UploadPageAdmin> {
  String? imagePath;
  String? pdfPath;

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController publisherController = TextEditingController();

  String selectedGenre = 'Lainnya'; // Default genre

  List<String> genres = [
    "Bahasa Indonesia",
    "Bahasa Inggris",
    "Informatika",
    "IPA (Ilmu Pengetahuan Alam)",
    "IPS (Ilmu Pengetahuan Sosial)",
    "Kepercayaan",
    "Matematika",
    "Pendidikan Pancasila",
    "Lainnya"
  ];

  @override
  void initState() {
    super.initState();
    // _checkAndRequestPermission();
  }

  // Future<void> _checkAndRequestPermission() async {
  //   if (await Permission.storage.request().isGranted) {
  //     // Izin diberikan, lakukan aksi yang memerlukan izin
  //     print('Izin storage sudah diberikan');
  //   } else {
  //     // Jika belum diberikan, tampilkan dialog atau pesan untuk meminta izin
  //     print('Izin storage belum diberikan');
  //   }
  // }

  Future<String> copyFileToExternalStorage(String cacheFilePath, String folderName) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String perpustakaanDirPath = '${externalDir!.path}/$folderName';

      // Buat folder perpustakaan jika belum ada
      Directory(perpustakaanDirPath).createSync(recursive: true);

      File cacheFile = File(cacheFilePath);
      String destinationPath = '$perpustakaanDirPath/${cacheFile.uri.pathSegments.last}';

      await cacheFile.copy(destinationPath);

      return destinationPath;
    } catch (e) {
      // ignore: avoid_print
      print('Error copying file: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null) {
      String cacheImagePath = result.files.single.path!;
      String externalImagePath = await copyFileToExternalStorage(cacheImagePath, 'images');

      setState(() {
        imagePath = externalImagePath;
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      String cachePdfPath = result.files.single.path!;
      String externalPdfPath = await copyFileToExternalStorage(cachePdfPath, 'pdfs');

      setState(() {
        pdfPath = externalPdfPath;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_validateForm()) {
      // Implementasi upload file ke server atau aksi lainnya
      if (imagePath != null && pdfPath != null) {
        // Simpan data buku ke dalam file JSON
        await addToBookJson(imagePath!, pdfPath!);
        setState(() {
          titleController.text = '';
          authorController.text = '';
          yearController.text = '';
          publisherController.text = '';
          selectedGenre = 'Lainnya';
          pdfPath = null;
          imagePath = null;
        });
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard_admin', (route) => false);
      } else {
        // ignore: avoid_print
        print('File not selected yet.');
      }
    }
  }

  bool _validateForm() {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        yearController.text.isEmpty ||
        publisherController.text.isEmpty ||
        selectedGenre.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Form Validation'),
            content: const Text('Please fill in all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<void> addToBookJson(String imagePath, String pdfPath) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String bookJsonPath = '${externalDir!.path}/book.json';

      List<dynamic> jsonData = [];
      if (File(bookJsonPath).existsSync()) {
        // Baca data saat ini dari book.json
        String jsonDataString = await File(bookJsonPath).readAsString();
        jsonData = json.decode(jsonDataString);
      }

      // Tambahkan data buku baru
      jsonData.add({
        'image_link': imagePath,
        'pdf_link': pdfPath,
        'nama_buku': titleController.text,
        'Author': authorController.text,
        'Tahun': int.parse(yearController.text),
        'Penerbit': publisherController.text,
        'genre': selectedGenre,
      });

      // Simpan kembali ke dalam book.json
      await File(bookJsonPath).writeAsString(json.encode(jsonData));
    } catch (e) {
      // ignore: avoid_print
      print('Error adding to book.json: $e');
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
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard_admin');
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          backgroundColor: const Color(0xFF5271FF),
        ),
        body: SafeArea(
          child: SingleChildScrollView( // Tambahkan widget SingleChildScrollView di sini
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: titleController,
                    hintText: "Masukkan Judul Buku",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: authorController,
                    hintText: "Masukkan Author Buku",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: yearController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // ignore: unused_local_variable
                      int? year = int.tryParse(value);

                    },
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Masukkan Tahun Rilis Buku",
                    ),
                  ),
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: publisherController,
                    hintText: "Masukkan Publisher Buku",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedGenre,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGenre = value!;
                      });
                    },
                    items: genres.map<DropdownMenuItem<String>>((String genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    hint: const Text('Select Genre'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  if (imagePath != null) Text('Image Path: $imagePath'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickPdf,
                    child: const Text('Pick PDF'),
                  ),
                  if (pdfPath != null) Text('PDF Path: $pdfPath'),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () { _uploadFile(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3131),
                        borderRadius: BorderRadius.circular(8)
                        ),
                      child: const Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                            ),
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