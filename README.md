# perpustakaan

A new Flutter project.

## Getting Started

sebelum menjalankan project tersebut masukkan command line dibawah ini
`flutter pub get`

seteleh terdownload sekarang tekang tombol `F5` lalu pilih sesuai device yang akan menjadi outputnya disini saya menggunakan android emulator.

jika belum menginstall flutter, dart dan android studio bisa menonton tutorialnya [disini](https://www.youtube.com/watch?v=EhGW4UYpKSE&ab_channel=GhostTogether) 

## Structure Folder
```bash
.
└── lib/
    ├── assets/
    ├── screen/
    ├── services/
    ├── Components/
    └── model/
```

| Nama Folder | Kegunaan                                                             |
| ----------- | -------------------------------------------------------------------- |
| Assets      | Menyimpan assets seperti gambar, pdf, json dan lain lainnya          |
| Service     | folder khusus menyimpan file service serperti pengekstract json file |
| Model       | folder khusus menyimpan model dari suatu json file                   |
| Components  | folder khusus menyimpan components seperti card, CustomButton dll    |
| Screens     | folder khusus screen seperti HomePage, Dashboard dll                 |


Q: Dimana pengaturan akunnya cara rubah admin dll
A: bisa edit file data.json yang berada di dalam assets

Q: Dimana buku/pdf disimpan?
A: buku/pdf yang di upload akan masuk ke dalam folder bawaan aplikasi yang bernama com.perpustakaan lalu di dalamnya berisi folder images dan pdfs, lalu file yg terupload masuk ke directory tadi dan ditulis path/data nya kedalam file book.json

Q: Dimana code upload PDF nya?
A: Code tersebut berada di dalam folder lib/screen/upload_admin.dart

Q: Dimana render PDFnya?
A: Pdf tersebut terender didalam dashboard_admin.dart/dashboard_user.dart
