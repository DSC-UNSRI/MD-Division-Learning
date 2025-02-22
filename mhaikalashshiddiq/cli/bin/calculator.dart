import 'dart:io';
import 'dart:math' as math;

void main(List<String> arguments) {
  print('Simple CLI Calculator');
  print('Available operations: +, -, *, /, ^');
  
  while (true) {
    try {
      print('\nEnter first number (or "exit" to quit):');
      String? input1 = stdin.readLineSync();
      
      if (input1?.toLowerCase() == 'exit') {
        print('Thank you for using the calculator!');
        break;
      }
      
      double num1 = double.parse(input1 ?? '');
      
      print('Enter operation (+, -, *, /, ^):');
      String? operation = stdin.readLineSync();
      
      if (operation == null || !['+', '-', '*', '/', '^'].contains(operation)) {
        print('Invalid operation! Please try again.');
        continue;
      }
      
      print('Enter second number:');
      double num2 = double.parse(stdin.readLineSync() ?? '');
      
      double result;
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
            print('Error: Division by zero!');
            continue;
          }
          result = num1 / num2;
          break;
        case '^':
          result = math.pow(num1, num2).toDouble();
          break;
        default:
          print('Invalid operation!');
          continue;
      }
      
      print('Result: $result');
      
    } catch (e) {
      print('Invalid input! Please enter valid numbers.');
    }
  }
}