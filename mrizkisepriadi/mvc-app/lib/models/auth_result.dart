import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? error;

  AuthResult({this.user, this.error});
}
