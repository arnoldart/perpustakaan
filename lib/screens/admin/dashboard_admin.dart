import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}
class _DashboardAdminState extends State<DashboardAdmin> {
  List<dynamic> allData = [];
  List<dynamic> searchResults = [];
  Map<String, List<dynamic>> groupedData = {};
  TextEditingController searchController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _logout(BuildContext context) {
    Provider.of<AuthModel>(context, listen: false).isLoggedIn = false;
  }

  Future<void> fetchData() async {
    try {
      // Baca data saat ini dari book.json
      List<dynamic> jsonData = await fetchBookData();

      setState(() {
        allData = jsonData;
        searchResults = List.from(allData);
        groupDataByGenre();
      });
    } catch (e) {
      // Handle errors, seperti file tidak ditemukan
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }

  Future<List<dynamic>> fetchBookData() async {
    try {
      final file = File('${(await getExternalStorageDirectory())!.path}/book.json');
      if (file.existsSync()) {
        String jsonData = await file.readAsString();
        return json.decode(jsonData);
      } else {
        // Jika file belum ada, kembalikan list kosong
        return [];
      }
    } catch (e) {
      // Handle errors, seperti file tidak ditemukan
      return [];
    }
  }

  void groupDataByGenre() {
    groupedData.clear();
    for (var book in searchResults) {
      String genre = book['genre'] ?? 'Lainnya'; // Sesuaikan dengan struktur data sesuai kebutuhan
      if (!groupedData.containsKey(genre)) {
        groupedData[genre] = [];
      }
      groupedData[genre]!.add(book);
    }
  }

  void searchBooks(String query) {
    setState(() {
      searchResults = allData
          .where((book) => book['nama_buku'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      groupDataByGenre(); // Update groupedData based on searchResults
    });
  }

  void navigateToBookDetailPage(dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          book: book,
          onDelete: () {
            onDeleteBook(book);
          },
        ),
      ),
    );
  }

  void onDeleteBook(dynamic book) {
    setState(() {
      allData.remove(book);
      searchResults.remove(book); // Remove from searchResults as well
      groupDataByGenre();
    });

    saveData();

    Navigator.pushReplacementNamed(context, '/dashboard_admin');
  }

  Future<void> saveData() async {
    try {
      final file = File('${(await getExternalStorageDirectory())!.path}/book.json');
      await file.writeAsString(json.encode(allData));
      // ignore: avoid_print
      print('Data saved successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<AuthModel>(context).isLoggedIn;

    // Melakukan pengecekan status login
    if (!isLoggedIn) {
      // Jika belum login, kembali ke halaman login
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF5271FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              // Tampilkan dialog konfirmasi logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Konfirmasi Logout'),
                    content: const Text('Apakah Anda yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: const Text('Iya'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Jika tidak, tutup dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Tidak'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Cari Nama Buku",
              ),
              onChanged: (query) {
                searchBooks(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                dynamic book = searchResults[index];
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        navigateToBookDetailPage(book);
                      },
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          height: 150,
                          child: Row(
                            children: [
                              Image.file(
                                File(book['image_link'],),
                                fit: BoxFit.fill,
                                width: 100,
                              ),
                              const SizedBox(width: 16),  // Beri jarak antara gambar dan teks
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book['nama_buku'],  // Ganti dengan properti judul dari data buku
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis, maxLines: 1,
                                    ),
                                    Text('Author: ${book['Author']}'),
                                    Text('Tahun: ${book['Tahun']}'),
                                    Text('Penerbit: ${book['Penerbit']}', overflow: TextOverflow.ellipsis, maxLines: 1,),
                                  ],
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
            ),
          )
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () { Navigator.pushReplacementNamed(context, '/upload_admin'); },
          child: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 25),
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
      ),
    );
  }
}


class BookDetailPage extends StatelessWidget {
  final dynamic book;
  final VoidCallback onDelete;

  const BookDetailPage({super.key, required this.book, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['nama_buku']),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Hapus Buku'),
                    content: const Text('Anda yakin ingin menghapus buku ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete();
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(File(book['pdf_link']))
    );
  }
}