import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListBukuUser extends StatefulWidget {
  const ListBukuUser({Key? key}) : super(key: key);

  @override
  State<ListBukuUser> createState() => ListBukuUserState();
}

class ListBukuUserState extends State<ListBukuUser> {
  List<dynamic> allData = [];
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<dynamic> jsonData = await fetchBookData();

      setState(() {
        allData = jsonData;
        searchResults = List.from(allData);
        searchResults.sort((a, b) => a['nama_buku']
            .toString()
            .toLowerCase()
            .compareTo(b['nama_buku'].toString().toLowerCase()));
      });
    } catch (e) {
      // Handle errors, such as file not found
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
        return json.decode(jsonData);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard_user');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            'List Buku',
            style: TextStyle(color: Colors.white, fontFamily: 'ErasBoldItc'),
          ),
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.blue, // Warna latar belakang header
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Nama Buku',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ErasBoldItc'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Author',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ErasBoldItc'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Kategori Buku',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ErasBoldItc'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children:
                              List.generate(searchResults.length, (index) {
                            final book = searchResults[index];
                            final backgroundColor =
                                index.isEven ? Colors.grey[200] : Colors.white;
                            return Container(
                              color: backgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        book['nama_buku'],
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        book['Author'],
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        book['genre'],
                                        style: const TextStyle(
                                            fontFamily: 'ErasBoldItc'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
