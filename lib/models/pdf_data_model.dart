class PdfData {
  final int id;
  // ignore: non_constant_identifier_names
  final String nama_buku;
  final String author;
  final String penerbit;
  // ignore: non_constant_identifier_names
  final String pdf_link;
  final String role;

  PdfData({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.nama_buku,
    required this.author,
    required this.penerbit,
    // ignore: non_constant_identifier_names
    required this.pdf_link,
    required this.role,
  });

  factory PdfData.fromJson(Map<String, dynamic> json) {
    return PdfData(
      id: json['id'],
      nama_buku: json['nama_buku'],
      author: json['author'],
      penerbit: json['penerbit'],
      pdf_link: json['pdf_link'],
      role: json['role'],
    );
  }

}

