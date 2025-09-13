import 'dart:io';
import 'dart:math';

// Fungsi untuk mendapatkan input angka dari pengguna
double getNumberInput(String prompt) {
  double? number;
  while (number == null) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null && input.isNotEmpty) {
      try {
        number = double.parse(input);
      } catch (e) {
        print("Input tidak valid. Masukkan angka yang benar.");
      }
    } else {
      print("Input tidak boleh kosong.");
    }
  }
  return number;
}

// Fungsi untuk mendapatkan input operator dari pengguna
String getOperatorInput() {
  String? operatorSymbol;
  List<String> validOperators = ['+', '-', '*', '/', '^'];
  while (operatorSymbol == null || !validOperators.contains(operatorSymbol)) {
    stdout.write("Masukkan operator (+, -, *, /, ^): ");
    operatorSymbol = stdin.readLineSync();
    if (operatorSymbol == null || !validOperators.contains(operatorSymbol)) {
      print("Operator tidak valid. Gunakan salah satu dari: +, -, *, /, ^");
    }
  }
  return operatorSymbol;
}

void main() {
  print("===================================");
  print("    Kalkulator CLI Sederhana     ");
  print("===================================");

  bool ulangi = true;

  while (ulangi) {
    // Mendapatkan input angka pertama
    double num1 = getNumberInput("Masukkan angka pertama: ");

    // Mendapatkan input operator
    String operator = getOperatorInput();

    // Mendapatkan input angka kedua
    double num2 = getNumberInput("Masukkan angka kedua: ");

    double hasil = 0;
    bool error = false;

    // Melakukan kalkulasi berdasarkan operator
    switch (operator) {
      case '+':
        hasil = num1 + num2;
        break;
      case '-':
        hasil = num1 - num2;
        break;
      case '*':
        hasil = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          print("Error: Tidak bisa melakukan pembagian dengan nol.");
          error = true;
        } else {
          hasil = num1 / num2;
        }
        break;
      case '^':
        hasil = pow(num1, num2).toDouble();
        break;
      default:
        print("Operator tidak dikenal.");
        error = true;
    }

    // Menampilkan hasil jika tidak ada error
    if (!error) {
      print("-----------------------------------");
      print("Hasil: $num1 $operator $num2 = $hasil");
      print("-----------------------------------");
    }

    // Menanyakan apakah pengguna ingin melakukan perhitungan lagi
    stdout.write("Apakah Anda ingin melakukan perhitungan lagi? (y/n): ");
    String? pilihan = stdin.readLineSync()?.toLowerCase();
    if (pilihan != 'y') {
      ulangi = false;
    }
    print("\n"); // Baris baru untuk pemisah antar perhitungan
  }

  print("===================================");
  print(" Terima kasih telah menggunakan   ");
  print("      Kalkulator CLI!            ");
  print("===================================");
}
