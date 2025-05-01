import 'dart:io';
import 'dart:math';

enum Operation { add, subtract, multiply, divide, power }

void main() {
  print('=== Kalkulator ===');
  
  while (true) {
    try {
      double num1 = getValidNumber('Angka pertama: ');
      
      Operation operation = getValidOperation();
      
      double num2 = getValidNumber('Angka kedua: ');
      
      double? result = calculate(num1, operation, num2);
      
      if (result != null) {
        print('\nHasil: ${formatResult(num1)} ${getOperationSymbol(operation)} ${formatResult(num2)} = ${formatResult(result)}');
      }
      
      if (!askToContinue()) {
        print('Terima kasih telah menggunakan kalkulator ini!');
        break;
      }
      
    } catch (e) {
      print('Error: $e');
      if (!askToContinue()) break;
    }
  }
}

double getValidNumber(String prompt) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync() ?? '';
    
    try {
      return double.parse(input);
    } catch (e) {
      print('Error: Masukkan angka yang valid!');
    }
  }
}

Operation getValidOperation() {
  while (true) {
    stdout.write('Masukkan operator (+, -, *, /, ^): ');
    String input = stdin.readLineSync() ?? '';
    
    switch (input.trim()) {
      case '+':
        return Operation.add;
      case '-':
        return Operation.subtract;
      case '*':
        return Operation.multiply;
      case '/':
        return Operation.divide;
      case '^':
        return Operation.power;
      default:
        print('Error: Operator tidak valid! Gunakan: +, -, *, /, ^');
    }
  }
}

String getOperationSymbol(Operation operation) {
  switch (operation) {
    case Operation.add:
      return '+';
    case Operation.subtract:
      return '-';
    case Operation.multiply:
      return '*';
    case Operation.divide:
      return '/';
    case Operation.power:
      return '^';
  }
}

double? calculate(double num1, Operation operation, double num2) {
  try {
    switch (operation) {
      case Operation.add:
        return num1 + num2;
      case Operation.subtract:
        return num1 - num2;
      case Operation.multiply:
        return num1 * num2;
      case Operation.divide:
        if (num2 == 0) {
          print('Error: Pembagian dengan nol tidak diperbolehkan!');
          return null;
        }
        return num1 / num2;
      case Operation.power:
        return pow(num1, num2).toDouble();
    }
  } catch (e) {
    print('Error dalam perhitungan: $e');
    return null;
  }
}

String formatResult(double number) {
  return number.truncateToDouble() == number 
      ? number.toInt().toString() 
      : number.toString();
}

bool askToContinue() {
  while (true) {
    stdout.write('\nIngin melakukan perhitungan lagi? (y/n): ');
    String input = stdin.readLineSync()?.toLowerCase() ?? '';
    if (input == 'y') return true;
    if (input == 'n') return false;
    print('Masukkan y atau n!');
  }
}