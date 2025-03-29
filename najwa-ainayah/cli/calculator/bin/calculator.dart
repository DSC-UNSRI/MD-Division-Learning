import 'dart:io';

void main() {
  while (true) {
    print('\n=== Kalkulator Sederhana CLI ===');
    print('1. Tambah');
    print('2. Kurang');
    print('3. Kali');
    print('4. Bagi');
    print('5. Keluar');

    stdout.write('Pilih operasi (1/2/3/4/5): ');
    String? pilihan = stdin.readLineSync();

    if (pilihan == '5') {
      print('Terima kasih telah menggunakan kalkulator!');
      break;
    }

    if (['1', '2', '3', '4'].contains(pilihan)) {
      stdout.write('Masukkan angka pertama: ');
      double? a = double.tryParse(stdin.readLineSync() ?? '');

      stdout.write('Masukkan angka kedua: ');
      double? b = double.tryParse(stdin.readLineSync() ?? '');

      if (a == null || b == null) {
        print('Input tidak valid. Harap masukkan angka.');
        continue;
      }

      double hasil;
      switch (pilihan) {
        case '1':
          hasil = a + b;
          break;
        case '2':
          hasil = a - b;
          break;
        case '3':
          hasil = a * b;
          break;
        case '4':
          if (b == 0) {
            print('Tidak bisa membagi dengan nol.');
            continue;
          }
          hasil = a / b;
          break;
        default:
          print('Pilihan tidak valid.');
          continue;
      }

      print('Hasil: $hasil');
    } else {
      print('Pilihan tidak valid. Silakan coba lagi.');
    }
  }
}
