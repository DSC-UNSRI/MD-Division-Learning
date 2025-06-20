import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('\nSimple CLI Calculator');
    print('1. Addition');
    print('2. Subtraction');
    print('3. Multiplication');
    print('4. Division');
    print('5. Exponentiation');
    print('6. Exit');
    stdout.write('Choose an operation (1-6): ');

    var choice = stdin.readLineSync();
    if (choice == '6') break;

    double? num1, num2;
    
    while (num1 == null) {
      stdout.write('Enter first number: ');
      num1 = double.tryParse(stdin.readLineSync() ?? '');
      if (num1 == null) {
        print('Invalid input! Please enter a valid number.');
      }
    }

    while (num2 == null) {
      stdout.write('Enter second number: ');
      num2 = double.tryParse(stdin.readLineSync() ?? '');
      if (num2 == null) {
        print('Invalid input! Please enter a valid number.');
      }
    }

    switch (choice) {
      case '1':
        print('Result: ${num1 + num2}');
        break;
      case '2':
        print('Result: ${num1 - num2}');
        break;
      case '3':
        print('Result: ${num1 * num2}');
        break;
      case '4':
        if (num2 == 0) {
          print('Error: Division by zero!');
        } else {
          print('Result: ${num1 / num2}');
        }
        break;
      case '5':
        if (num1 < 0 && num2 % 1 != 0) {
          print('Error: Cannot calculate negative base with non-integer exponent.');
        } else {
          print('Result: ${num1}^${num2} = ${pow(num1, num2)}');
        }
        break;
      default:
        print('Invalid choice!');
    }
  }
}
