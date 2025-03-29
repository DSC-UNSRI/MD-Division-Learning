import 'dart:io';
import 'dart:math' as math;

const String version = '0.0.1';

bool isNumeric(String str) {
  return double.tryParse(str) != null;
}

void main(List<String> arguments) {
  print("Halo, ini kalkulator sederhana saya");
  print("Gunakan operasi +, -, *, /, dan ^");

  while (true) {
    double? num1, num2;
    double? result;
    String? operation;

    try {
      stdout.write("\nMasukkan angka pertama: ");
      while (num1 == null) {
        String? input = stdin.readLineSync();
        if (input == null || !isNumeric(input)) {
          print('Harap masukkan angka yang valid!');
          stdout.write("Masukkan angka pertama: ");
        } else {
          num1 = double.parse(input);
        }
      }

      stdout.write("Masukkan operasi yang ingin digunakan (+, -, *, /, ^): ");
      operation = stdin.readLineSync();

      if (operation == null || !['+', '-', '*', '/', '^'].contains(operation)) {
        print('Harap gunakan operasi yang valid!');
        continue;
      }

      stdout.write("Masukkan angka kedua: ");
      while (num2 == null) {
        String? input = stdin.readLineSync();
        if (input == null || !isNumeric(input)) {
          print('Harap masukkan angka yang valid!');
          stdout.write("Masukkan angka kedua: ");
        } else {
          num2 = double.parse(input);
        }
      }

      switch (operation) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            print("Error: Tidak bisa membagi dengan nol!");
            continue;
          }
          result = num1 / num2;
          break;
        case '^':
          result = math.pow(num1, num2).toDouble();
          break;
        default:
          print("Operasi tidak valid!");
          continue;
      }

      print("Hasil: $result");

    } catch (e) {
      print("Terjadi kesalahan: ${e.toString()}");
    }
    break;
  }
}
