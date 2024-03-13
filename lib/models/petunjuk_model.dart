class PetunjukModel {
  List<Map<String, String>> titlesAndDescriptions;

  PetunjukModel({
    required this.titlesAndDescriptions,
  });
}

// Data yang digunakan
List<PetunjukModel> contents = [
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "1. Menambahkan Buku",
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description':
            "Tekan tombol Tambah Buku untuk membuka page tambah buku",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-4.png",
        'description':
            "Isi semua data yang diperlukan untuk menambahkan buku jika tidak maka akan terjadi peringatan, jika sudah selesai klik tombol Tambah",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "2. Menghapus Buku",
        'image': "img/petunjuk_admin/petunjuk-13.png",
        'description': "Tekan atau buka salah satu buku yang ingin dihapus",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-12.png",
        'description':
            "Jika sudah klik tombol sampah untuk menghapus buku tersebut",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "3. Tambah Siswa",
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description': "Tekan tombol menu di pojok kanan atas",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-2.png",
        'description':
            "Jika sudah klik tombol tambah siswa untuk membuka page tambah siswa",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-6.png",
        'description':
            "Isi semua data yang diperlukan untuk menambahkan siswa jika tidak maka akan terjadi peringatan, jika sudah selesai klik tombol Tambah",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "4. Melihat List Buku",
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description': "Tekan tombol menu di pojok kanan atas",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-2.png",
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
        'title': "4. Melihat Lokasi Sekolah SMPN 17 Kerinci",
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description': "Tekan tombol menu di pojok kanan atas",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-2.png",
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
        'title': "5. Kategori Buku",
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description':
            "Tekan tombol menu di pojok kanan atas, jika sudah klik tombol kategori buku untuk melihat kategori buku yang ada",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-11.png",
        'description':
            "Pilih salah satu kategori buku untuk melihat list buku yang ada pada kategori tersebut",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-15.png",
        'description':
            "Pada contoh tersebut kita memilih kategori buku Bahasa Indonesia",
      },
      {
        'title': "",
        'image': "img/petunjuk_admin/petunjuk-16.png",
        'description':
            "Dan pada halaman ini kita dapat melihat list buku yang ada pada kategori Bahasa Indonesia",
      },
    ],
  ),
  PetunjukModel(
    titlesAndDescriptions: [
      {
        'title': "6. Mencari buku",
        'image': "img/petunjuk_admin/petunjuk-1.png",
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
        'image': "img/petunjuk_admin/petunjuk-1.png",
        'description':
            "Tekan tombol menu di pojok kanan atas, jika sudah klik tombol keluar untuk keluar dari akun",
      },
    ],
  )
];
