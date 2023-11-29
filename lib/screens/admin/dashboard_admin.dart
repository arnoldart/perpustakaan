import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/auth_model.dart';
import 'package:perpustakaan/models/pdf_data_model.dart';
import 'package:provider/provider.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});


  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> fetchPdfData() async {
      String data = await DefaultAssetBundle.of(context).loadString("lib/assets/book.json");
      return json.decode(data);
    }
    
    bool isLoggedIn = Provider.of<AuthModel>(context).isLoggedIn;

    // Melakukan pengecekan status login
    if (!isLoggedIn) {
      // Jika belum login, kembali ke halaman login
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/auth');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () { Navigator.pushReplacementNamed(context, '/setting_admin');},
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchPdfData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> pdfData = snapshot.data as List<dynamic>;

            return ListView.builder(
              itemCount: pdfData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pdfData[index]['nama_buku']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${pdfData[index]['author']}'),
                      Text('Tahun: ${pdfData[index]['tahun']}'),
                      Text('Penerbit: ${pdfData[index]['penerbit']}'),
                    ],
                  ),
                  onTap: () {
                    // Tambahkan logika untuk menangani ketika item diklik
                    // Misalnya, membuka tautan PDF atau menampilkan informasi lebih lanjut
                    print('PDF Link: ${pdfData[index]['pdf_link']}');
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
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
    );
  }
}

// class DashboardAdmin extends StatefulWidget {
//   const DashboardAdmin({super.key});

//   @override
//   State<DashboardAdmin> createState() => _DashboardAdminState();
// }

// class _DashboardAdminState extends State<DashboardAdmin> {

//   @override
//   Widget build(BuildContext context) {
//     bool isLoggedIn = Provider.of<AuthModel>(context).isLoggedIn;

//     // Melakukan pengecekan status login
//     if (!isLoggedIn) {
//       // Jika belum login, kembali ke halaman login
//       Future.delayed(Duration.zero, () {
//         Navigator.pushReplacementNamed(context, '/auth');
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard Admin'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () { Navigator.pushReplacementNamed(context, '/setting_admin');},
//           ),
//         ],
//       ),
//       body: Text('Dashboard Admin'),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           // margin: const EdgeInsets.symmetric(horizontal: 25),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(8)
//             ),
//           child: const Center(
//             child: Text(
//               "Upload",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16
//                 ),
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: BottomAppBar(
//       //   child: Container(
//       //     padding: EdgeInsets.symmetric(vertical: 10.0),
//       //     child: Row(
//       //       mainAxisAlignment: MainAxisAlignment.center,
//       //       children: [
//       //         Text('Page $currentPage of $pages'),
//       //         SizedBox(width: 20),
//       //         ElevatedButton(
//       //           onPressed: () {
//       //             if (currentPage > 0) {
//       //               _pdfViewController.setPage(currentPage - 1);
//       //             }
//       //           },
//       //           child: Text('Previous'),
//       //         ),
//       //         SizedBox(width: 20),
//       //         ElevatedButton(
//       //           onPressed: () {
//       //             if (currentPage < pages - 1) {
//       //               _pdfViewController.setPage(currentPage + 1);
//       //             }
//       //           },
//       //           child: Text('Next'),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }