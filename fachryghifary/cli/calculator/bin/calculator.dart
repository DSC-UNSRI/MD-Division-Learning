import 'dart:io';

int addition(int a, int b) {
  return a + b;
}

int substraction(int a, int b) {
  return a - b;
}

int multiplication(int a, int b) {
  return a * b;
}

int division(int a, int b) {
  if (b == 0) {
    throw Exception("Can't divide by zero");
  }
  return (a / b).round();
}

int exponentiation(int a, int b) {
  if (a == 0 && b == 0) {
    throw Exception("Syntax Error");
  }
  if (b == 0) {
    return 1;
  }
  for (int i = 0; i < b; i++) {
    a *= a;
  }
  return a;
}

void main() {
  int a = int.parse(stdin.readLineSync()!);
  int b = int.parse(stdin.readLineSync()!);
  print(addition(a, b));
  print(substraction(a, b));
  print(multiplication(a, b));
  print(division(a, b));
  print(exponentiation(a, b));
}
