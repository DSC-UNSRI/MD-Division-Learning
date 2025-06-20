// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk HapticFeedback
// import 'dart:math' as math; // Untuk operasi pangkat jika diperlukan

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0"; // Menampilkan hasil atau input utama
  String _currentInput = ""; // Angka yang sedang diketik
  String _expressionToDisplay = ""; // Ekspresi lengkap yang ditampilkan di atas
  double _num1 = 0;
  String _operand = "";
  bool _shouldResetOutput =
      false; // Untuk mereset output setelah operator atau =

  // Fungsi untuk menangani penekanan tombol
  void _buttonPressed(String buttonText) {
    HapticFeedback.lightImpact(); // Memberikan feedback getar ringan
    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        _currentInput = "";
        _expressionToDisplay = "";
        _num1 = 0;
        _operand = "";
        _shouldResetOutput = false;
      } else if (buttonText == "C") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          if (_currentInput.isEmpty) {
            _output = "0";
            // Jika expressionToDisplay hanya berisi angka yang dihapus, reset juga
            if (_expressionToDisplay == _output ||
                double.tryParse(_expressionToDisplay) != null) {
              _expressionToDisplay = "";
            }
          } else {
            _output = _currentInput;
          }
          // Perbarui expressionToDisplay jika tidak mengandung operator
          if (!_expressionToDisplay.contains(RegExp(r'[+\-×÷%]'))) {
            _expressionToDisplay = _currentInput.isEmpty ? "" : _currentInput;
          }
        } else if (_operand.isNotEmpty) {
          // Menghapus operator terakhir
          _operand = "";
          // Hapus operator dan spasi dari _expressionToDisplay
          if (_expressionToDisplay.endsWith(" $_operand ") ||
              _expressionToDisplay.endsWith(_operand)) {
            // Ini perlu logika yang lebih baik untuk menghapus operator terakhir secara akurat
            // Untuk sementara, kita bisa set _expressionToDisplay ke _num1 jika ada
            _expressionToDisplay =
                _num1 != 0 ? _formatDisplayNumber(_num1) : "";
          }
          _output = _formatDisplayNumber(_num1); // Tampilkan kembali num1
          _shouldResetOutput = false;
        } else {
          // Jika tidak ada input atau operator, C berfungsi seperti AC
          _output = "0";
          _currentInput = "";
          _expressionToDisplay = "";
          _num1 = 0;
          _shouldResetOutput = false;
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷" ||
          buttonText == "%") {
        if (_currentInput.isNotEmpty || _num1 != 0) {
          // Pastikan ada angka sebelumnya
          if (_operand.isNotEmpty && _currentInput.isNotEmpty) {
            // Ada operasi sebelumnya dan input baru, hitung dulu
            _performCalculation();
            // Hasil dari _performCalculation sudah ada di _num1 dan _output
          } else if (_currentInput.isNotEmpty) {
            // Ini adalah angka pertama atau angka setelah =
            _num1 = double.parse(_currentInput);
          }
          // Jika _num1 sudah ada (dari input sebelumnya atau hasil kalkulasi),
          // kita bisa langsung set operand baru.
          // _num1 sudah diupdate oleh _performCalculation jika ada.

          _operand = buttonText;
          _expressionToDisplay = "${_formatDisplayNumber(_num1)} $_operand ";
          _currentInput = "";
          _shouldResetOutput = true; // Siap untuk input angka kedua
        }
      } else if (buttonText == "=") {
        if (_currentInput.isNotEmpty && _operand.isNotEmpty) {
          _performCalculation();
          _expressionToDisplay = _output; // Tampilkan hasil akhir di ekspresi
          // _num1 sudah berisi hasil, _operand dan _currentInput sudah direset oleh _performCalculation
          _shouldResetOutput =
              true; // Reset output jika pengguna mulai mengetik angka baru
          _currentInput =
              _output; // Simpan hasil ke currentInput jika pengguna ingin melanjutkan operasi dengan hasil ini
          _operand = ""; // Reset operand setelah =
        }
      } else if (buttonText == ".") {
        if (_shouldResetOutput) {
          _currentInput = "0.";
          _output = "0.";
          _expressionToDisplay += "0.";
          _shouldResetOutput = false;
        } else if (!_currentInput.contains(".")) {
          if (_currentInput.isEmpty) _currentInput = "0";
          _currentInput += ".";
          _output = _currentInput;
          _expressionToDisplay =
              _currentInput; // Atau tambahkan ke ekspresi yang ada
        }
      } else {
        // Input angka (0-9)
        if (_shouldResetOutput) {
          _currentInput = buttonText;
          _output = buttonText;
          _expressionToDisplay += buttonText; // Tambahkan ke ekspresi yang ada
          _shouldResetOutput = false;
        } else {
          if (_currentInput == "0" && buttonText != "0") {
            // Hindari 00, 01, dll.
            _currentInput = buttonText;
          } else if (_currentInput != "0" ||
              buttonText != "0" ||
              _currentInput.contains(".")) {
            // Izinkan 0 jika sudah ada desimal atau bukan angka pertama
            _currentInput += buttonText;
          }
          _output = _currentInput;
          // Update expressionToDisplay: jika sebelumnya adalah operator, tambahkan angka baru
          if (_expressionToDisplay.endsWith(" $_operand ") ||
              _expressionToDisplay.isEmpty && _num1 == 0) {
            if (_expressionToDisplay.isEmpty && _num1 == 0) {
              _expressionToDisplay = _currentInput;
            } else {
              _expressionToDisplay += _currentInput;
            }
          } else if (_expressionToDisplay.contains(RegExp(r'[+\-×÷%]'))) {
            // Jika ekspresi sudah ada operator, dan kita menambahkan digit ke angka kedua
            // kita perlu cara yang lebih baik untuk membangun _expressionToDisplay
            // Untuk sementara, kita bisa coba replace angka terakhir di ekspresi
            // Ini adalah bagian yang rumit untuk ditampilkan secara live dan akurat
            // Cara sederhana: _expressionToDisplay = "${_formatDisplayNumber(_num1)} $_operand $_currentInput";
            // Namun, ini akan menimpa jika pengguna mengedit angka kedua.
            // Mungkin lebih baik hanya menampilkan _currentInput di _output, dan _expressionToDisplay
            // hanya diupdate saat operator atau = ditekan.
            // Untuk sekarang, kita biarkan _expressionToDisplay diupdate secara bertahap.
            // Jika _expressionToDisplay sudah ada angka setelah operator, kita append.
            // Contoh: "12 + 3" menjadi "12 + 34"
            // Ini butuh logika parsing yang lebih baik atau hanya update saat operator/sama dengan.
            // Untuk UI yang lebih sederhana, _expressionToDisplay bisa saja hanya menampilkan _num1, _operand, dan _currentInput saat mereka ada.
            // Kita akan coba membangun _expressionToDisplay secara bertahap
            if (_operand.isNotEmpty && _num1 != 0) {
              _expressionToDisplay =
                  "${_formatDisplayNumber(_num1)} $_operand $_currentInput";
            } else {
              _expressionToDisplay = _currentInput;
            }
          } else {
            // Jika tidak ada operator, expression sama dengan currentInput
            _expressionToDisplay = _currentInput;
          }
        }
      }
      // Batasi panjang _output dan _expressionToDisplay untuk tampilan
      if (_output.length > 12) _output = _output.substring(0, 12);
      if (_expressionToDisplay.length > 25) {
        _expressionToDisplay = _expressionToDisplay.substring(
          _expressionToDisplay.length - 25,
        );
      }
    });
  }

  void _performCalculation() {
    if (_operand.isEmpty || _currentInput.isEmpty) return;

    double num2 = double.parse(_currentInput);
    double result = 0;

    if (_operand == "+") {
      result = _num1 + num2;
    } else if (_operand == "-") {
      result = _num1 - num2;
    } else if (_operand == "×") {
      result = _num1 * num2;
    } else if (_operand == "÷") {
      if (num2 == 0) {
        _output = "Error";
        _expressionToDisplay = "Tidak bisa dibagi nol";
        _currentInput = "";
        _num1 = 0;
        // _operand = ""; // Biarkan operand jika pengguna ingin mencoba lagi dengan angka lain
        _shouldResetOutput = true;
        return;
      }
      result = _num1 / num2;
    } else if (_operand == "%") {
      // Persentase dari num1: (num1 * num2) / 100 atau num1 * (num2/100)
      // Atau bisa juga num2% dari num1. Kita ambil num1 * (num2/100)
      result = _num1 * (num2 / 100);
    }

    _output = _formatDisplayNumber(result);
    _num1 = result; // Simpan hasil untuk operasi selanjutnya
    // _operand = ""; // Jangan reset operand di sini, biarkan untuk chained operation jika "=" tidak ditekan
    _currentInput = ""; // Reset input saat ini, karena sudah dihitung
    _shouldResetOutput = true; // Siap untuk input baru atau operator baru
  }

  String _formatDisplayNumber(double number) {
    // Format hasil: hilangkan .0 jika bilangan bulat
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      // Batasi angka desimal, misal 5. Hindari notasi ilmiah untuk angka besar/kecil.
      String formatted = number.toStringAsFixed(5);
      // Hapus trailing zeros setelah desimal
      formatted = formatted.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      return formatted;
    }
  }

  // Widget untuk membuat tombol kalkulator
  Widget _buildButton(
    String buttonText, {
    Color? textColor,
    Color? buttonColor,
    int flex = 1,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Warna default jika tidak dispesifikasikan
    textColor ??= isDark ? Colors.white : Colors.black87;
    buttonColor ??= isDark ? Color(0xFF3A3A3C) : Colors.grey[200];

    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: isDark ? 1.0 : 3.0,
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w400),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
        isDark ? Color(0xFF121212) : Color(0xFFF0F0F0);
    final Color displayTextColor =
        isDark ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color displayBackgroundColor =
        isDark ? Color(0xFF1E1E1E) : Colors.white;
    final Color expressionTextColor =
        isDark ? Colors.white.withOpacity(0.6) : Colors.black54;

    final Color operatorButtonColor =
        isDark ? Color(0xFFF9A825) : Colors.orangeAccent;
    final Color operatorTextColor = isDark ? Colors.black : Colors.white;
    final Color functionButtonColor =
        isDark ? Color(0xFF616161) : Colors.grey[400]!;
    final Color functionTextColor = isDark ? Colors.white : Colors.black87;
    final Color numberButtonColor =
        isDark ? Color(0xFF3A3A3C) : Colors.grey[200]!;
    final Color numberTextColor = isDark ? Colors.white : Colors.black87;
    final Color equalsButtonColor = isDark ? Color(0xFFF57C00) : Colors.orange;
    final Color equalsTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Kalkulator Flutter',
          style: TextStyle(
            color: displayTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  margin: EdgeInsets.only(bottom: 16.0, top: 10.0),
                  decoration: BoxDecoration(
                    color: displayBackgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _expressionToDisplay.isEmpty
                              ? " "
                              : _expressionToDisplay,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: expressionTextColor,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _output,
                          style: TextStyle(
                            fontSize: 56.0,
                            fontWeight: FontWeight.w300,
                            color: displayTextColor,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildButton(
                          "AC",
                          textColor: functionTextColor,
                          buttonColor: functionButtonColor,
                        ),
                        _buildButton(
                          "C",
                          textColor: functionTextColor,
                          buttonColor: functionButtonColor,
                        ),
                        _buildButton(
                          "%",
                          textColor: operatorTextColor,
                          buttonColor: operatorButtonColor,
                        ),
                        _buildButton(
                          "÷",
                          textColor: operatorTextColor,
                          buttonColor: operatorButtonColor,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _buildButton(
                          "7",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "8",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "9",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "×",
                          textColor: operatorTextColor,
                          buttonColor: operatorButtonColor,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _buildButton(
                          "4",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "5",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "6",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "-",
                          textColor: operatorTextColor,
                          buttonColor: operatorButtonColor,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _buildButton(
                          "1",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "2",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "3",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "+",
                          textColor: operatorTextColor,
                          buttonColor: operatorButtonColor,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _buildButton(
                          "0",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                          flex: 2,
                        ),
                        _buildButton(
                          ".",
                          textColor: numberTextColor,
                          buttonColor: numberButtonColor,
                        ),
                        _buildButton(
                          "=",
                          textColor: equalsTextColor,
                          buttonColor: equalsButtonColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
