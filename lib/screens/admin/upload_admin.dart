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

  String selectedGenre = 'Action'; // Default genre

  List<String> genres = ['Action', 'non-Fiction', 'Science Fiction', 'Mystery', 'Thriller', 'Romance', 'Fantasy', 'Biography', 'History', 'Other'];

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
      print('Error copying file: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
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
        print('File uploaded: $imagePath, $pdfPath');
      } else {
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
            title: Text('Form Validation'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
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
        'Tahun': yearController.text,
        'Penerbit': publisherController.text,
        'genre': selectedGenre,
      });

      // Simpan kembali ke dalam book.json
      await File(bookJsonPath).writeAsString(json.encode(jsonData));
    } catch (e) {
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
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView( // Tambahkan widget SingleChildScrollView di sini
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                UploadTextField(
                  controller: titleController,
                  hintText: "Masukkan Judul Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: authorController,
                  hintText: "Masukkan Author Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: yearController,
                  hintText: "Masukkan Tahun Rilis Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: publisherController,
                  hintText: "Masukkan Publisher Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
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
                  hint: Text('Select Genre'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                if (imagePath != null) Text('Image Path: $imagePath'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickPdf,
                  child: Text('Pick PDF'),
                ),
                if (pdfPath != null) Text('PDF Path: $pdfPath'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadFile,
                  child: Text('Upload File'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}