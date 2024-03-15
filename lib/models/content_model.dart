class OnboardingContent {
  List<Map<String, String>> titlesDescriptionsAndImages;

  OnboardingContent({
    required this.titlesDescriptionsAndImages,
  });
}

OnboardingContent contents = OnboardingContent(
  titlesDescriptionsAndImages: [
    {
      "title": "",
      "description":
          "Sebuah aplikasi yang memberikan dorongan semangat dalam proses pembelajaran, dengan menyediakan beragam koleksi buku yang dapat diakses, memungkinkan pengguna untuk belajar secara fleksibel, di mana pun dan kapan pun mereka berada.",
      "background": "img/welcome.png",
      "image": "img/welcome.gif"
    },
    {
      "title": "Perhatian",
      "description":
          "Jika Belum terdaftar silahkan hubungi petugas perpustakaan \n\n Jika sudah terdaftar silahkan tekan tombol done",
      "background": "img/guide1.png",
      "image": ""
    },
  ],
);
