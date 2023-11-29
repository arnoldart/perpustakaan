class PdfData {
  final int id;
  final String nama_buku;
  final String author;
  final String penerbit;
  final String pdf_link;
  final String role;

  PdfData({
    required this.id,
    required this.nama_buku,
    required this.author,
    required this.penerbit,
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

