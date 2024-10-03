[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) adalah permainan arena pertempuran multipemain daring (MOBA) yang dirilis pada 2014. Permainan ini dikembangkan dengan mesin permainan internal oleh perusahaan [Nival](http://nival.com/), sebagian besar ditulis dalam C++.

Permainan ini terdiri dari dua bagian: Kastil dan Pertarungan. Pemain berperan sebagai Tuan atau Nyonya. Di Kastil, pemain membangun bangunan, merekrut Pahlawan, dan memilih Bakat untuk mereka. Di bagian Pertarungan, pemain mengendalikan Pahlawan dan menggunakan Bakat untuk melawan pemain lain dalam pertarungan tim.

Pada tahun 2024, kode sumber dari bagian Pertarungan permainan ini dibuka di bawah [lisensi khusus](LICENSE.md), yang melarang penggunaan komersial tetapi sepenuhnya terbuka untuk komunitas permainan, studi, dan penelitian. Silakan baca ketentuan [perjanjian lisensi](LICENSE.md) dengan cermat sebelum menggunakannya.

## Isi dalam repositori ini
- `pw` — kode utama bagian pertarungan
- `pw_publish` — klien bagian pertarungan yang telah dikompilasi dengan kode curang dan editor klien
- `pw/branches/r1117/Bin/PF_Editor.exe` — editor data permainan

## Persiapan
Anda perlu mengunduh data dari repositori ini dan menggabungkan folder `Bin` dengan data utama permainan. Berikut caranya:

1. Salin folder `pw_publish/branch/Client/PvP/Bin` ke `pw/branches/r1117`, menggantikan file yang ada.
2. Jalankan klien dengan kode curang `pw/branches/r1117/Bin/PW_Game.exe`.
3. Jika berhasil, Anda akan melihat jendela pemuatan tanpa gambar dan layar hitam.
4. Di folder `Profiles -> game.cfg`, ubah nilai `local_game 0` menjadi `local_game 1`.
5. Jalankan klien dengan kode curang. Sekarang Anda seharusnya melihat lobi di mana Anda dapat memilih peta, pahlawan, dan memulai pertarungan.
6. Dalam permainan, tekan tombol Tilde (~) pada keyboard, dan Anda akan melihat konsol untuk memasukkan kode curang.

Jika terjadi kesalahan, periksa file log di `pw/branches/r1117/Bin/logs`.

## Data Permainan
Data dapat diedit melalui editor dan terletak di `pw/branches/r1117/Data`

Dengan mengedit data, Anda bisa:
1. Mengubah deskripsi talenta dan kemampuan pahlawan.
2. Memodifikasi talenta dan kemampuan pahlawan.
3. Mengubah logika creep dan menara.
4. Menambahkan pahlawan dan kemampuan baru.
5. Menambahkan bakat baru.
6. Memodifikasi dan menambahkan efek.
7. Mengubah dan menambahkan model dan animasi.

Saat mengubah data, tidak perlu membuat klien baru dari kode. Cukup tekan `File -> Save`, dan semua perubahan akan langsung muncul di klien permainan `PW_Game`. Sebagai contoh, Anda bisa mencoba mengubah deskripsi bakat atau kemampuan pahlawan tertentu.

## Editor Data Permainan
Editor data permainan terletak di `pw/branches/r1117/Bin/PF_Editor.exe`

Saat pertama kali membuka editor, Anda perlu mengonfigurasi jalur ke `Data`:
1. `Tools -> File System Configuration`.
2. `Add -> WinFileSystem`.
3. Tetapkan folder Data sebagai akar sistem: `pw/branches/r1117/Data`.
4. Tutup jendela.
5. Di editor: `Views -> Object Browser` dan `Views -> Properties Editor`. Ini adalah dua panel utama untuk mengedit data.

Tab editor dapat dipindahkan dan ditambatkan.

## Klien Permainan dengan Kode Curang
Dalam repositori ini, Anda bisa menemukan klien permainan yang telah dikompilasi dengan kode curang `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`

Diperlukan agar folder `Localization`, `Profiles`, dan `Data` berada di sebelah folder `Bin`. Oleh karena itu, selama persiapan, perlu dipindahkan ke folder `pw`. Jika ada perubahan kode, klien perlu dikompilasi ulang.

## Cara Memulai PvP
1. Di `Profiles -> game.cfg`, ubah `local_game 0`.
2. Tambahkan `login_address <alamat server>`.
3. Jalankan permainan dengan parameter `-dev_login MyNickname`.

## Cara Memulai Permainan dengan Bot
1. Ganti nama file `Profiles -> private.cfg_example` menjadi `private.cfg`.
2. Buka file dengan Notepad.
3. Temukan `AT BEGINNING GAME`.
4. Tambahkan baris baru: `add_ai bots` — ini akan menugaskan bot AI untuk setiap pahlawan dalam permainan.

## Pemecahan Potensi Kesalahan
1. Ganti nama file `Profiles -> private.cfg_example` menjadi `private.cfg`.
2. Buka file dengan Notepad.
3. Temukan bagian `performance section`.
4. Temukan baris `setvar gfx_fullscreen = 0` — ini akan memulai permainan dalam mode jendela, yang mungkin lebih stabil.
5. Pengaturan optimasi lainnya juga dapat diubah di bagian `performance section`.

## Ucapan Terima Kasih
Kepada komunitas **Prime World: Nova** atas kontribusi mereka dalam dokumentasi dan perbaikan kesalahan.
