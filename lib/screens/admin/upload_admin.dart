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
  final judulBukuController = TextEditingController();
  final authorBukuController = TextEditingController();
  final tahunBukuController = TextEditingController();
  final penerbitBukuController = TextEditingController();

  String selectedGenre = 'Action'; // Default genre

   String? imagePath;
  String? pdfPath;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        imagePath = result.files.single.path;
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
      setState(() {
        pdfPath = result.files.single.path;
      });
    }
  }

  Future<void> uploadData() async {
    // Validasi untuk memastikan tidak ada TextField yang kosong
    if (judulBukuController.text.isEmpty ||
        authorBukuController.text.isEmpty ||
        tahunBukuController.text.isEmpty ||
        penerbitBukuController.text.isEmpty ||
        imagePath == null ||
        pdfPath == null) {
      // Tampilkan pesan atau lakukan tindakan yang sesuai untuk memberi tahu pengguna
      // bahwa semua field harus diisi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Semua field harus diisi dan file gambar serta PDF harus dipilih.'),
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
      return;
    }

    // Read existing data from data_pdf.json
    List<dynamic> existingData = await fetchData();

    // Add new data to the list
    existingData.add({
      "nama_buku": judulBukuController.text,
      "Author": authorBukuController.text,
      "Tahun": tahunBukuController.text,
      "Penerbit": penerbitBukuController.text,
      "pdf_link": pdfPath,
      "image_link": imagePath,
      "genre": selectedGenre,
    });

    // Save the updated data back to data_pdf.json
    await saveData(existingData);

    // Reset the text controllers and paths after uploading data
    // judulBukuController.clear();
    // authorBukuController.clear();
    // tahunBukuController.clear();
    // penerbitBukuController.clear();
    // imagePath = null;
    // pdfPath = null;

    // You can add additional logic here, e.g., show a success message.
  }

  Future<List<dynamic>> fetchData() async {
    try {
      final file = File('${(await getExternalStorageDirectory())!.path}/data_pdf.json');
      String data = await file.readAsString();
      return json.decode(data);
    } catch (e) {
      // Handle errors, such as file not found
      return [];
    }
  }

  Future<void> saveData(List<dynamic> newData) async {
    final file = File('${(await getExternalStorageDirectory())!.path}/data_pdf.json');
    await file.writeAsString(jsonEncode(newData));
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
                  controller: judulBukuController,
                  hintText: "Masukkan Judul Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: authorBukuController,
                  hintText: "Masukkan Author Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: tahunBukuController,
                  hintText: "Masukkan Tahun Terbit Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                UploadTextField(
                  controller: penerbitBukuController,
                  hintText: "Masukkan Penerbit Buku",
                  obscureText: true,
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: selectedGenre,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGenre = newValue!;
                    });
                  },
                  items: <String>['Action', 'Pendidikan', 'Fiksi', 'Lainnya']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pilih Gambar'),
                ),
                // if (imagePath != null) Text('Gambar terpilih: $imagePath'),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickPdf,
                  child: Text('Pilih PDF'),
                ),
                // if (pdfPath != null) Text('PDF terpilih: $pdfPath'),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    uploadData();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}