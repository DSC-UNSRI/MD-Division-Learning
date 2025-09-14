import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/form_controller.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController _authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name'; 
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), 

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'), 
                validator: (value) => FormController.validateEmail(value ?? ''),
              ),
              const SizedBox(height: 16), 

              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              const SizedBox(height: 24), 

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await _authController.registerWithEmail(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (context.mounted) {
                      if (result.user != null) {
                        _authController.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration successful. Please check your email to verify.')), // Menggunakan const
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.error ?? '')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
