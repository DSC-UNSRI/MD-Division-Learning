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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.lock_open_rounded,
                  size: 80, color: Theme.of(context).primaryColor),
              SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => FormController.validateEmail(value ?? ''),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    FormController.validatePassword(value ?? ''),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: Text('Login'),
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
                            MaterialPageRoute(builder: (context) => CartView()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(result.error ?? 'Login failed')),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.g_mobiledata, size: 28),
                  label: Text('Login with Google'),
                  onPressed: () async {
                    final result = await _authController.loginWithGoogle();
                    if (context.mounted) {
                      if (result.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CartView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(result.error ?? 'Google login failed')),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterView()),
                  );
                },
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
