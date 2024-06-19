import 'package:absensi_adhimix/screens/home_screen.dart';
import 'package:absensi_adhimix/screens/register_screen.dart';
import 'package:absensi_adhimix/services/auth_service_signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscured = true;
  final AuthServiceSignin _authService = AuthServiceSignin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Image.asset(
                  'assets/images/adhimix-logo2.png',
                  height: 150,
                ),
                const SizedBox(height: 50),
                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    labelText: 'Password',
                    labelStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Forgot Password Text
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implementasi aksi lupa password
                    },
                    child: Text(
                      'Lupa Password?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isSuccess = await loginWithEmailPassword();
                      if (isSuccess) {
                        final user = FirebaseAuth.instance.currentUser;
                        final userDoc = await _firestore
                            .collection('users')
                            .doc(user!.uid)
                            .get();
                        final username = userDoc['username'];
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(username: username),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'LOGIN',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // Login With Google Account
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isSuccess = await loginWithGoogle();
                      if (isSuccess) {
                        final user = FirebaseAuth.instance.currentUser;
                        final userDoc = await _firestore
                            .collection('users')
                            .doc(user!.uid)
                            .get();
                        final username = userDoc['username'];
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(username: username),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Image.asset(
                            'assets/images/google_logo.png',
                            fit: BoxFit.cover,
                            height: 36,
                            width: 36,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'LOGIN WITH GOOGLE ACCOUNT',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Or Login With Google Account',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum Punya Akun?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Daftar Di sini!',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> loginWithEmailPassword() async {
    String email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      print('Email dan Password tidak boleh kosong');
      return false;
    }

    if (!email.contains('@')) {
      final username = email;
      email = await _authService.getEmailFromUsername(username) ?? "";
      if (email.isEmpty) {
        print('Username tidak ditemukan');
        return false;
      }
    }

    try {
      await _authService.signIn(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      return user != null;
    } catch (e) {
      print('Error during sign-in: $e');
      return false;
    }
  }
}
