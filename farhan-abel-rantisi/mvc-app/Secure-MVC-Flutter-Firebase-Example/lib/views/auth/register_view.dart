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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, size: 72, color: Colors.green),
              const SizedBox(height: 16),
              Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) => FormController.validateEmail(value ?? ''),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordObscured ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _isPasswordObscured = !_isPasswordObscured);
                          },
                        ),
                      ),
                      validator: (value) => FormController.validatePassword(value ?? ''),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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
                                MaterialPageRoute(builder: (context) => LoginView()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.error ?? '')),
                              );
                            }
                          }
                        }
                      },
                      child: Text('Register'),
                    ),

                    const SizedBox(height: 12),
                    
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Already have an account? Login"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
