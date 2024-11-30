import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TODO: 1. Deklarasikan variabel
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';

  bool _obscurePassword = true;

  //TODO: 1.Membuat method _signUp
  void _signUp()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = _fullnameController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if(password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]'))||
        !password.contains(RegExp(r'[a-z]'))||
        !password.contains(RegExp(r'[0-9]'))||
        !password.contains(RegExp(r'[!@#\\\$%^&*(),.?":{}|<>]'))){
      setState(() {
        _errorText = 'Minimal 8 karakter, kombinasi [A-Z], [a-z], [0-9], [!@#\\\$%^&*(),.?":{}|<>]';
      });
      return;
    }
    //simpan data pengguna di SharedPreferences
    prefs.setString('Full Name', name);
    prefs.setString('Username', username);
    prefs.setString('Password', password);

    //buat navigasi ke signinscreen
    Navigator.pushReplacementNamed(context, '/signin');
  }


  //TODO: 2.Membuat method dispose
  @override
  void dispose(){
    //TODO: Implement dispose
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2. Pasang AppBar
      appBar: AppBar(title: const Text('Sign Up')),
      // TODO: 3. Pasang body
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                child: Column(
                  // TODO: 4. Atur mainAxisAlignment dan crossAxisAlignment
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Lengkap Pengguna",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // TODO: 6. Pasang TextFormField Nama Pengguna
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Pengguna",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // TODO: 7. Pasang TextFormField Kata Sandi
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Kata Sandi",
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = ! _obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    // TODO: 8. Pasang ElevatedButton Sign In
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: () {
                      _signUp();
                    }, child: const Text('Sign Up')),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}