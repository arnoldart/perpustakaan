import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perpustakaan/components/custom_expansiontile.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DashboardUser extends StatefulWidget {
  const DashboardUser({super.key});

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  List<dynamic> allData = [];
  List<dynamic> searchResults = [];
  Map<String, List<dynamic>> groupedData = {};
  TextEditingController searchController = TextEditingController();
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    groupDataByGenre();
  }

  void _logout(BuildContext context) {
    Provider.of<AuthModel>(context, listen: false).isLoggedIn = false;
  }

  Future<void> fetchData() async {
    try {
      List<dynamic> jsonData = await fetchBookData();
      String jsonDataFromAssets =
          await rootBundle.loadString('lib/assets/book.json');
      List<dynamic> booksFromAssets = json.decode(jsonDataFromAssets);

      List<dynamic> mergedData = [...jsonData, ...booksFromAssets];

      setState(() {
        allData = mergedData;
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
      final file =
          File('${(await getExternalStorageDirectory())!.path}/book.json');
      if (file.existsSync()) {
        String jsonData = await file.readAsString();
        List<dynamic> books = json.decode(jsonData);

        // Mengurutkan buku berdasarkan ID secara menurun
        books.sort((a, b) => b['id'].compareTo(a['id']));

        return books;
      }
    } catch (e) {
      // Tangani kesalahan saat membaca file atau parsing JSON
      // ignore: avoid_print
      print('Error reading or parsing file: $e');
    }

    // Jika file tidak ditemukan atau terjadi kesalahan lainnya, kembalikan list kosong
    return [];
  }

  void searchBooks(String query) {
    setState(() {
      searchResults = allData
          .where((book) =>
              book['nama_buku'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      groupDataByGenre();
    });
  }

  void navigateToBookDetailPage(dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          book: book,
        ),
      ),
    );
  }

  void groupDataByGenre() {
    groupedData.clear();
    for (var book in searchResults) {
      String genre = book['genre'] ?? 'Lainnya';
      if (!groupedData.containsKey(genre)) {
        groupedData[genre] = [];
      }
      groupedData[genre]!.add(book);
    }
  }

  void onDeleteBook(dynamic book) {
    setState(() {
      allData.remove(book);
      searchResults.remove(book);
      groupDataByGenre();
    });

    saveData();

    Navigator.pushReplacementNamed(context, '/dashboard_admin');
  }

  Future<void> saveData() async {
    try {
      final file =
          File('${(await getExternalStorageDirectory())!.path}/book.json');
      await file.writeAsString(json.encode(allData));
      // print('Data saved successfully.');
    } catch (e) {
      // print('Error saving data: $e');
    }
  }

  List<dynamic> filterBooksBySelectedCategories() {
    // Jika tidak ada genre yang dipilih, tampilkan semua buku
    if (selectedCategories.isEmpty) {
      return List.from(allData);
    } else {
      // Filter buku berdasarkan genre yang dipilih
      List<dynamic> filteredBooks = [];
      for (var genre in selectedCategories) {
        filteredBooks.addAll(groupedData[genre] ?? []);
      }
      return filteredBooks.toSet().toList(); // Menghapus duplikat
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
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF5271FF),
            ),
            child: Text(
              'Perpustakaan',
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontFamily: 'ErasBoldItc'),
            ),
          ),
          ListTile(
            title: const Text(
              'List Buku',
              style: TextStyle(fontFamily: 'ErasBoldItc'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/list_buku_user');
            },
          ),
          ListTile(
            title: const Text(
              'Lokasi',
              style: TextStyle(fontFamily: 'ErasBoldItc'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/lokasi_user');
            },
          ),
          ListTile(
            title: const Text(
              'Petunjuk',
              style: TextStyle(fontFamily: 'ErasBoldItc'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/petunjuk_user');
            },
          ),
          const Divider(),
          Column(
            children: [
              CustomExpansionTile(
                title: const Text('Kategori Buku',
                    style: TextStyle(fontSize: 16, fontFamily: 'ErasBoldItc')),
                children: [
                  for (var genre in groupedData.keys)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Jika genre yang sedang aktif ditekan lagi, hapus filter
                          if (selectedCategories.contains(genre)) {
                            selectedCategories.remove(genre);
                            if (selectedCategories.isEmpty) {
                              searchResults = List.from(allData);
                            } else {
                              searchResults = filterBooksBySelectedCategories();
                            }
                          } else {
                            // Jika tidak, filter buku berdasarkan genre yang dipilih
                            selectedCategories.clear();
                            selectedCategories.add(genre);
                            searchResults = filterBooksBySelectedCategories();
                          }
                        });
                      },
                      child: ListTile(
                        title: Text(
                          genre,
                          style: TextStyle(
                            fontFamily: 'ErasBoldItc',
                            fontSize: 14,
                            fontWeight: selectedCategories.contains(genre)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selectedCategories.contains(genre)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        ],
      )),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5271FF),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontFamily: 'ErasBoldItc'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              // Tampilkan dialog konfirmasi logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Konfirmasi Logout',
                      style: TextStyle(fontFamily: 'ErasBoldItc'),
                    ),
                    content: const Text(
                      'Apakah Anda yakin ingin logout?',
                      style: TextStyle(fontFamily: 'ErasBoldItc'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: const Text(
                          'Iya',
                          style: TextStyle(fontFamily: 'ErasBoldItc'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Jika tidak, tutup dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Tidak',
                          style: TextStyle(fontFamily: 'ErasBoldItc'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            child: TextField(
              style: const TextStyle(fontFamily: 'ErasBoldItc'),
              controller: searchController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          navigateToBookDetailPage(book);
                        },
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            // padding: EdgeInsets.all(12),
                            height: 150,
                            child: Row(
                              children: [
                                _buildBookImage(book['image_link']),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book['nama_buku'],
                                        style: const TextStyle(
                                          fontFamily: 'ErasBoldItc',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        'Author: ${book['Author']}',
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                      Text(
                                        'Tahun: ${book['Tahun']}',
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                      Text(
                                        'Penerbit: ${book['Penerbit']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                      Text(
                                        'Kategori: ${book['genre']}',
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
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
                }),
          )
        ],
      ),
    );
  }
}

Widget _buildBookImage(String imagePath) {
  if (imagePath.startsWith('img/pdf')) {
    return Image.asset(
      imagePath,
      fit: BoxFit.fill,
      width: 100,
    );
  } else {
    return Image.file(
      File(imagePath),
      fit: BoxFit.fill,
      width: 100,
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final dynamic book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            book['nama_buku'],
            style: const TextStyle(fontFamily: 'ErasBoldItc'),
          ),
        ),
        body: _buildPdf(book['pdf_link']));
  }
}

Widget _buildPdf(String pdfPath) {
  if (pdfPath.startsWith('pdf/')) {
    // Gunakan AssetImage jika path dimulai dengan 'lib/assets/'
    return SfPdfViewer.asset(pdfPath);
  } else {
    // Gunakan FileImage jika path tidak dimulai dengan 'lib/assets/'
    return SfPdfViewer.file(File(pdfPath));
  }
}
