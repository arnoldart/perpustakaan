class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent(
      {required this.image, required this.title, required this.description});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      title: "Selamat Datang di \n Digital Library \n SMPN 17 Kerinci",
      description:
          "Aplikasi yang bikin kamu makin semangat belajar, dengan banyaknya koleksi buku yang bisa kamu baca, kamu bisa belajar dimana saja dan kapan saja",
      image: "img/welcome.png"),
  UnboardingContent(
      title: "Petunjuk",
      description: "Jika Belum terdaftar silahkan hubungi petugas perpustakaan",
      image: "img/guide1.png"),
  UnboardingContent(
      title: "Petunjuk",
      description: "Jika sudah terdaftar silahkan tekan tombol done",
      image: "img/guide2.png"),
];
