import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:perpustakaan/models/pdf_data_model.dart';
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

  Future<void> fetchData() async {
    try {
      final file = File('${(await getExternalStorageDirectory())!.path}/data_pdf.json');
      String jsonData = await file.readAsString();
      setState(() {
        allData = json.decode(jsonData);
        searchResults = List.from(allData); // Copy allData to searchResults initially
        groupDataByGenre();
      });
    } catch (e) {
      // Handle errors, such as file not found
      print('Error fetching data: $e');
    }
  }

  void groupDataByGenre() {
    groupedData.clear();
    for (var book in searchResults) {
      String genre = book['genre'];
      if (!groupedData.containsKey(genre)) {
        groupedData[genre] = [];
      }
      groupedData[genre]!.add(book);
    }
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
  }

  Future<void> saveData() async {
    try {
      final file = File('${(await getExternalStorageDirectory())!.path}/data_pdf.json');
      await file.writeAsString(json.encode(allData));
    } catch (e) {
      print('Error saving data: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
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
              itemCount: groupedData.keys.length,
              itemBuilder: (context, genreIndex) {
                String currentGenre = groupedData.keys.elementAt(genreIndex);
                List<dynamic> books = groupedData[currentGenre]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        currentGenre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 250.0,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, bookIndex) {
                          return GestureDetector(
                            onTap: () {
                              navigateToBookDetailPage(books[bookIndex]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              width: 150.0,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      books[bookIndex]['image_link'], 
                                      fit: BoxFit.contain,
                                      
                                    ),
                                  ),
                                  Text(
                                    books[bookIndex]['nama_buku'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text('Author: ${books[bookIndex]['Author']}'),
                                  Text('Tahun: ${books[bookIndex]['Tahun']}'),
                                  Text('Penerbit: ${books[bookIndex]['Penerbit']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () { Navigator.pushReplacementNamed(context, '/upload_admin'); },
          child: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.black,
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

  BookDetailPage({required this.book, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['nama_buku']),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Hapus Buku'),
                    content: Text('Anda yakin ingin menghapus buku ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete();
                          Navigator.of(context).pop(); // Pop to return to the dashboard
                        },
                        child: Text('Hapus'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        book['pdf_link'],
      )
    );
  }
}