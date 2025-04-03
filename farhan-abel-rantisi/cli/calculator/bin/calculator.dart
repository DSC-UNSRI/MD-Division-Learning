import 'dart:io';
import 'dart:math';

void main() {
  print("Simple CLI Calculator");
  print("Available operations: +, -, *, /, ^ (exponent)");

  stdout.write("Enter first number: ");
  double? num1 = double.tryParse(stdin.readLineSync()!);

  stdout.write("Enter operation (+, -, *, /, ^): ");
  String? operation = stdin.readLineSync();

  stdout.write("Enter second number: ");
  double? num2 = double.tryParse(stdin.readLineSync()!);

  if (num1 == null || num2 == null || operation == null) {
    print("Invalid input. Please enter valid numbers and operator.");
    return;
  }

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
        print("Error: Division by zero is not allowed.");
        return;
      }
      result = num1 / num2;
      break;
    case '^':
      result = pow(num1, num2).toDouble();
      break;
    default:
      print("Invalid operation.");
      return;
  }

  print("Result: $result");
}
