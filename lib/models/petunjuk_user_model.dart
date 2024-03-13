class PetunjukModel {
  List<Map<String, String>> titlesAndDescriptions;

  PetunjukModel({
    required this.titlesAndDescriptions,
  });
}

List<PetunjukModel> contents = [
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "1. Melihat list buku",
        'image': "img/petunjuk_user/petunjuk-1.png",
        'description':
            "Tekan tombol Tambah Buku untuk membuka page tambah buku",
      },
      {
        'title': "",
        'image': "img/petunjuk_user/petunjuk-2.png",
        'description':
            "Jika sudah klik tombol list buku untuk melihat list buku",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-7.png",
        'description': "Dihalaman ini anda dapat melihat list buku yang ada",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "2. Melihat Lokasi Sekolah SMPN 17 Kerinci",
        'image': "img/petunjuk_user/petunjuk-1.png",
        'description': "Tekan tombol menu di pojok kanan atas",
      },
      {
        'title': "",
        'image': "img/petunjuk_user/petunjuk-2.png",
        'description':
            "Jika sudah klik tombol lokasi untuk melihat lokasi sekolah SMPN 17 Kerinci",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-8.png",
        'description':
            "Dihalaman ini anda dapat melihat lokasi sekolah SMPN 17 Kerinci melalui gambar atau google maps",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-9.png",
        'description':
            "Dihalaman ini anda dapat melihat lokasi sekolah SMPN 17 Kerinci dengan menggunakan gambar yang interactive",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "3. Kategori Buku",
        'image': "img/petunjuk_user/petunjuk-1.png",
        'description':
            "Tekan tombol menu di pojok kanan atas, jika sudah klik tombol kategori buku untuk melihat kategori buku yang ada",
      },
      {
        'title': "",
        'image': "img/petunjuk_user/petunjuk-3.png",
        'description':
            "Dihalaman ini anda dapat melihat kategori buku yang ada",
      },
      {
        'title': "",
        'image': "img/petunjuk_user/petunjuk-4.png",
        'description':
            "Pada contoh tersebut kita memilih kategori buku Bahasa Indonesia",
      },
      {
        'title': "",
        'image': "img/petunjuk_user/petunjuk-5.png",
        'description':
            "Dan pada halaman ini kita dapat melihat list buku yang ada pada kategori Bahasa Indonesia",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "6. Mencari buku",
        'image': "img/petunjuk_user/petunjuk-1.png",
        'description':
            "Tekan searchbar pada dibagian atas lalu ketikkan buku yang ingin dicari",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-14.png",
        'description':
            "Pada contoh tersebut kita mencari buku dengan judul Bahasa Indonesia dan ini hasilnya",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "7. Keluar dari akun",
        'image': "img/petunjuk_user/petunjuk-1.png",
        'description':
            "Tekan tombol menu di pojok kanan atas, jika sudah klik tombol keluar untuk keluar dari akun",
      },
    ],
  )
];
