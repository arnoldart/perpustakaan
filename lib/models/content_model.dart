class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent(
      {required this.image, required this.title, required this.description});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      title: "Selamat Datang \n pada \n Digital Library \n SMPN 17 Kerinci",
      description:
          "Sebuah aplikasi yang memberikan dorongan semangat dalam proses pembelajaran, dengan menyediakan beragam koleksi buku yang dapat diakses, memungkinkan pengguna untuk belajar secara fleksibel, di mana pun dan kapan pun mereka berada.",
      image: "img/welcome.png"),
  UnboardingContent(
      title: "Perhatian",
      description: "Jika Belum terdaftar silahkan hubungi petugas perpustakaan",
      image: "img/guide1.png"),
  UnboardingContent(
      title: "Perhatian",
      description: "Jika sudah terdaftar silahkan tekan tombol done",
      image: "img/guide2.png"),
];
