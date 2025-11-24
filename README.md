# SportZone (Mobile)
Aplikasi SportZone adalah aplikasi mobile yang mirip dengan website sportzone.id. Ini adalah aplikasi area serba olahraga, cocok untuk forum global. Kesannya adalah modern dan mudah diingat karena merupakan gaya internasional. SportZone.id cocok untuk platform berita & forum dengan target generasi muda.

## Nama & NPM Anggota Kelompok
- Josh Christmas Rommlynn (2406395291)
- Theo Samuel (2406496366)
- Ahmad Yaqdhan (2406399081)
- Andrew Wanarahardja (2406407373)
- Ausy Dhafa Adhitama (2406417954)

## Deskripsi aplikasi (nama dan fungsi aplikasi)
### Profile
Modul ini akan menampilkan profil user website. Informasi yang akan ditampilkan mencakup:
- Foto profil pengguna
- Nama
- Username
- Tanggal lahir
- Daftar post & komentar yang pernah dibuat oleh pengguna
- Produk yang dijual oleh pengguna (apabila akun ini adalah akun Penjual)
- Artikel yang dibuat oleh pengguna (apabila akun ini adalah akun Editor)

Modul ini juga akan menghandle pembuatan menu Login dan Register.

### Artikel / News
Modul ini berisi artikel dan berita mengenai olahraga yang bisa ditulis oleh admin dan editor. Informasi yang akan ditampilkan mencakup:
- Judul artikel
- Thumbnail
- Konten
- Komentar

User lain dapat menaruh komentar di postingan tersebut. Komentar akan menampilkan foto profil, nama user, dan komentar user. Foto profil dan nama user apabila diklik akan menavigasi ke profile user tersebut.

### Discussion Posts / Forum
Modul ini berisi sistem forum seperti platform Twitter. Informasi yang akan ditampilkan mencakup:
- Konten singkat berupa sebuah opini atau pertanyaan pembuka
- Komentar

### Products (show, edit, filter)
Modul ini berfungsi sebagai sebuah toko untuk menjual produk olahraga. Informasi yang akan ditampilkan pada tiap-tiap produk mencakup:
- Nama produk
- Harga
- Deskripsi atau detail produk
- Gambar produk (bisa lebih dari satu)
- Informasi kontak penjual apabila pengguna berminat ingin beli

### Admin Page
Modul ini berfungsi sebagai tempat admin mengontrol apa yang terjadi pada website. Informasi yang ditampilkan mencakup:
- Daftar produk dalam bentuk non-card
  Terdapat tombol edit & delete pada masing-masing produk. Admin juga dapat menambah produk melalui menu ini.
- Daftar user
  Admin dapat menambah & menghapus user melalui menu ini. Admin juga dapat menyetel role dari tiap-tiap akun.
- Log aktivitas
  Daftar aktivitas yang dilakukan di website. Aktivitas seperti membuat akun, menghapus produk, dsb akan tercatat di sini

Modul ini juga akan menghandle pembuatan Homepage dan Navbar.

## Daftar modul yang diimplementasikan beserta pembagian kerja per anggota
- Josh Christmas Rommlynn: login dan register page
- Theo Samuel: Modul Products
- Andrew Wanarahardja: Modul news
- Ahmad Yaqdhan: Admin dan Home Page

## Peran atau aktor pengguna aplikasi
### Admin
Administrator merupakan pemilik dan pengelola utama situs web.
Memiliki hak akses penuh terhadap seluruh modul dan konten yang terdapat di dalam sistem.
Hak dan Tanggung Jawab:
- Mengelola seluruh data pengguna, konten, dan produk.
- Melakukan pengawasan dan moderasi terhadap aktivitas pengguna.
- Mengedit, menghapus, atau memperbarui informasi pada semua modul.
- Menjaga keamanan dan stabilitas sistem secara keseluruhan.

### Pengguna (User)
Pengguna merupakan anggota terdaftar yang dapat berinteraksi dengan konten dan komunitas di dalam situs web, namun tidak memiliki izin untuk membuat konten utama atau produk.
Hak dan Tanggung Jawab:
- Memberikan komentar pada artikel, forum, dan produk.
- Memberikan reaction (seperti like, dislike, atau emoji) terhadap konten.
- Melihat dan memperbarui profil pribadi.
- Mengakses artikel, forum, dan daftar produk.
  
Batasan Akses:
- Tidak dapat membuat atau mengedit artikel.
- Tidak dapat menambahkan atau mengelola produk.

### Tamu (Guest)
Tamu adalah pengunjung yang belum terdaftar atau belum melakukan proses masuk (sign in) pada sistem.
Hak dan Tanggung Jawab:
- Dapat melihat artikel, forum, dan produk yang tersedia untuk publik.
  
Batasan Akses:
- Tidak dapat memberikan komentar atau reaction.
- Tidak dapat membuat, mengedit, atau berinteraksi dengan konten.
- Tidak memiliki akses ke fitur pengguna yang memerlukan autentikasi.

### Penjual (Seller)
Penjual merupakan pengguna yang memiliki izin untuk menambahkan dan mengelola produk dalam sistem marketplace.
Hak dan Tanggung Jawab:
- Membuat dan mempublikasikan produk baru.
- Menentukan harga, menambahkan deskripsi, serta mengunggah gambar produk.
- Menyediakan informasi kontak yang dapat dihubungi calon pembeli.
- Mengelola daftar produk yang telah dibuat.
Batasan Akses:
- Tidak memiliki akses untuk membuat artikel atau berita.

### Editor / Author
Editor atau Author merupakan pengguna dengan wewenang untuk membuat dan mempublikasikan konten artikel pada situs web.

Hak dan Tanggung Jawab:
- Membuat, mengedit, dan mempublikasikan artikel atau berita.
- Mengelola komentar pada artikel yang diterbitkan.
- Menyunting konten untuk menjaga kualitas dan konsistensi informasi.

Batasan Akses:
- Tidak memiliki izin untuk membuat atau mengelola produk.

## Alur Pengintegrasian dengan Web Service
1. Buat path atau views pada Django yang mungkin dibutuhkan spesifik ke aplikasi Flutter
2. Integrasi dilakukan ke aplikasi Flutter dalam urutan sebagai berikut:
   - Akun (Login, Logout, Register)
   - Admin
   - Produk
   - Article
3. Dilakukan testing terhadap integrasi
4. Integrasi selesai!
