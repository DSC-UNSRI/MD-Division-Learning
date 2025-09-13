import 'package:flutter/material.dart';
import 'package:testing/views/auth/register_view.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/form_controller.dart';
import '../cart/cart_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;

  final Color navy = const Color(0xFF001F54);
  final Color brokenWhite = const Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brokenWhite,
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F54),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: FormController.validateEmail,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: _isPasswordObscured,
                  validator: FormController.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: navy,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildButton(
                  label: 'Login',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final result = await _authController.loginWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (context.mounted) {
                        if (result.user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartView(),
                            ),
                          );
                        } else {
                          _showError(result.error);
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildButton(
                  label: 'Login with Google',
                  onPressed: () async {
                    final result = await _authController.loginWithGoogle();
                    if (context.mounted) {
                      if (result.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartView(),
                          ),
                        );
                      } else {
                        _showError(result.error);
                      }
                    }
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  },
                  child: Text(
                    'Don’t have an account? Register',
                    style: TextStyle(color: navy),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) => validator(value ?? ''),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: navy),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: navy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: navy.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: navy, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : navy,
          foregroundColor: isOutlined ? navy : Colors.white,
          side: isOutlined ? BorderSide(color: navy, width: 2) : null,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isOutlined ? 0 : 2,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Something went wrong')),
    );
  }
}
