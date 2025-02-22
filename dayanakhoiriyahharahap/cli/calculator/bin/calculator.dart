import 'dart:io';

void main() {
  print("Calculator");

  double num1 = getValidNumber("Enter first number:");

  print("Enter operator (+, -, *, /, ^):");
  String? operator = getValidOperator();

  double? num2;
  if (operator != '^') {
    num2 = getValidNumber("Enter second number:");
  }

  double result;
  switch (operator) {
    case '+':
      result = num1 + num2!;
      break;
    case '-':
      result = num1 - num2!;
      break;
    case '*':
      result = num1 * num2!;
      break;
    case '/':
      if (num2 == 0) {
        print("Cannot divide by zero.");
        return;
      }
      result = num1 / num2!;
      break;
    case '^':
      result = num1 * num1; // Squaring the number
      break;
    default:
      print("Invalid operator.");
      return;
  }

  print("Result: $result");
}

double getValidNumber(String prompt) {
  double? number;
  do {
    print(prompt);
    number = double.tryParse(stdin.readLineSync() ?? '');
    if (number == null) {
      print("Invalid input. Please enter a valid number.");
    }
  } while (number == null);
  return number;
}

String getValidOperator() {
  String? operator;
  do {
    operator = stdin.readLineSync();
    if (operator == null || !['+', '-', '*', '/', '^'].contains(operator)) {
      print("Invalid operator. Please enter one of (+, -, *, /, ^):");
      operator = null;
    }
  } while (operator == null);
  return operator;
}
