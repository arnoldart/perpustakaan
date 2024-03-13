import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perpustakaan/components/upload_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class UploadPageAdmin extends StatefulWidget {
  const UploadPageAdmin({Key? key}) : super(key: key);

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

  bool isTitleEmpty = false;
  bool isAuthorEmpty = false;
  bool isYearEmpty = false;
  bool isPublisherEmpty = false;
  bool isImageNotSelected = false;
  bool isPdfNotSelected = false;

  @override
  void initState() {
    super.initState();
  }

  Future<String> copyFileToExternalStorage(
      String cacheFilePath, String folderName) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String perpustakaanDirPath = '${externalDir!.path}/$folderName';

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

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null) {
      String cacheImagePath = result.files.single.path!;
      String externalImagePath =
          await copyFileToExternalStorage(cacheImagePath, 'images');

      setState(() {
        imagePath = externalImagePath;
        isImageNotSelected = false;
      });
    } else {
      setState(() {
        imagePath = null;
        isImageNotSelected = true;
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
      String externalPdfPath =
          await copyFileToExternalStorage(cachePdfPath, 'pdfs');

      setState(() {
        pdfPath = externalPdfPath;
        isPdfNotSelected = false;
      });
    } else {
      setState(() {
        pdfPath = null;
        isPdfNotSelected = true;
      });
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      isImageNotSelected = imagePath == null;
      isPdfNotSelected = pdfPath == null;
    });

    if (_validateForm()) {
      if (!isImageNotSelected && !isPdfNotSelected) {
        await addToBookJson(imagePath!, pdfPath!);
        setState(() {
          titleController.text = '';
          authorController.text = '';
          yearController.text = '';
          publisherController.text = '';
          selectedGenre = 'Lainnya';
          pdfPath = null;
          imagePath = null;
          isImageNotSelected = false;
          isPdfNotSelected = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard_admin', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih file PDF dan gambar terlebih dahulu.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _validateForm() {
    setState(() {
      isTitleEmpty = titleController.text.isEmpty;
      isAuthorEmpty = authorController.text.isEmpty;
      isYearEmpty = yearController.text.isEmpty;
      isPublisherEmpty = publisherController.text.isEmpty;
    });

    if (isTitleEmpty ||
        isAuthorEmpty ||
        isYearEmpty ||
        isPublisherEmpty ||
        selectedGenre.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addToBookJson(String imagePath, String pdfPath) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String bookJsonPath = '${externalDir!.path}/book.json';

      List<dynamic> jsonData = [];
      int lastId = 0; // ID terakhir, default 0 jika belum ada buku
      if (File(bookJsonPath).existsSync()) {
        String jsonDataString = await File(bookJsonPath).readAsString();
        jsonData = json.decode(jsonDataString);

        // Cari ID terbesar
        for (var book in jsonData) {
          int id = book['id'];
          if (id > lastId) {
            lastId = id;
          }
        }
      }

      // Tambahkan buku dengan ID yang lebih besar dari ID terakhir
      jsonData.add({
        'id': lastId + 1, // ID baru
        'image_link': imagePath,
        'pdf_link': pdfPath,
        'nama_buku': titleController.text,
        'Author': authorController.text,
        'Tahun': int.parse(yearController.text),
        'Penerbit': publisherController.text,
        'genre': selectedGenre,
      });

      await File(bookJsonPath).writeAsString(json.encode(jsonData));
    } catch (e) {
      // Tangani kesalahan saat menambahkan ke book.json
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
          title: const Text('Tambah Buku',
              style: TextStyle(color: Colors.white, fontFamily: 'ErasBoldItc')),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: titleController,
                    hintText: "Masukkan Judul Buku",
                    obscureText: false,
                    errorText:
                        isTitleEmpty ? "Harap masukkan judul buku" : null,
                  ),
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: authorController,
                    hintText: "Masukkan Author Buku",
                    obscureText: false,
                    errorText:
                        isAuthorEmpty ? "Harap masukkan author buku" : null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: yearController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        isYearEmpty = value.isEmpty;
                      });
                    },
                    style: const TextStyle(fontFamily: 'ErasBoldItc'),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isYearEmpty ? Colors.red : Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isYearEmpty ? Colors.red : Colors.black),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Masukkan Tahun Rilis Buku",
                        errorText: isYearEmpty
                            ? "Harap masukkan tahun rilis buku"
                            : null,
                        errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontFamily: 'ErasBoldItc'),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Ubah warna menjadi merah
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                  const SizedBox(height: 20),
                  UploadTextField(
                    controller: publisherController,
                    hintText: "Masukkan Publisher Buku",
                    obscureText: false,
                    errorText: isPublisherEmpty
                        ? "Harap masukkan publisher buku"
                        : null,
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
                        child: Text(
                          genre,
                          style: const TextStyle(fontFamily: 'ErasBoldItc'),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      'Select Genre',
                      style: TextStyle(fontFamily: 'ErasBoldItc'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5271FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Pick Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'ErasBoldItc',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isImageNotSelected)
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Harap pilih gambar buku',
                        style: TextStyle(
                            color: Colors.red, fontFamily: 'ErasBoldItc'),
                      ),
                    ),
                  if (imagePath != null) Text('Image Path: $imagePath'),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickPdf,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5271FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Pick PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'ErasBoldItc',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isPdfNotSelected)
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Harap pilih file PDF buku',
                        style: TextStyle(
                            color: Colors.red, fontFamily: 'ErasBoldItc'),
                      ),
                    ),
                  if (pdfPath != null) Text('PDF Path: $pdfPath'),
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
                              fontSize: 16,
                              fontFamily: 'ErasBoldItc'),
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
