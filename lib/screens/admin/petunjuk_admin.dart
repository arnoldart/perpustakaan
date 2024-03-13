import 'package:flutter/material.dart';
import 'package:perpustakaan/models/petunjuk_model.dart';

class PetunjukAdmin extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const PetunjukAdmin({Key? key});

  @override
  State<PetunjukAdmin> createState() => _PetunjukAdminState();
}

class _PetunjukAdminState extends State<PetunjukAdmin> {
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
          title: const Text(
            'Petunjuk Admin',
            style: TextStyle(color: Colors.white, fontFamily: 'ErasBoldItc'),
          ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contents.map((petunjuk) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: petunjuk.titlesAndDescriptions.map((item) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item['title']!.isNotEmpty)
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ErasBoldItc',
                                  ),
                                ),
                              if (item['title']!.isNotEmpty)
                                const SizedBox(height: 12),
                              Center(
                                child: Image.asset(
                                  item['image']!,
                                  height: 600,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['description']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ErasBoldItc',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
