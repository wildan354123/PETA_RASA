import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorText = "";
  bool _isSignIn = false;
  bool _obscurePassword = true;


  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
      SharedPreferences prefs) async {
    final encryptedNamaLengkap = prefs.getString('NamaLengkap') ?? '';
    final encryptedUsername = prefs.getString('UserName') ?? '';
    final encryptedEmail = prefs.getString('Email') ?? '';
    final encryptedPassword = prefs.getString('Password') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (encryptedNamaLengkap.isEmpty ||
        encryptedUsername.isEmpty ||
        encryptedEmail.isEmpty ||
        encryptedPassword.isEmpty ||
        keyString.isEmpty ||
        ivString.isEmpty) {
      return {};
    }

    try {
      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decryptedNamaLengkap =
      encrypter.decrypt64(encryptedNamaLengkap, iv: iv);
      final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
      final decryptedEmail = encrypter.decrypt64(encryptedEmail, iv: iv);
      final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

      return {
        'NamaLengkap': decryptedNamaLengkap,
        'UserName': decryptedUsername,
        'Email': decryptedEmail,
        'Password': decryptedPassword,
      };
    } catch (e) {
      return {};
    }
  }

  void _signin() async {
    final String userNameOrEmail = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _errorText = '';
    });

    if (userNameOrEmail.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = "Username/Email dan Password tidak boleh kosong.";
      });
      return;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = await _retrieveAndDecryptDataFromPrefs(prefs);

      if (data.isNotEmpty) {
        final decryptedUsername = data['UserName'];
        final decryptedPassword = data['Password'];
        final decryptedEmail = data['Email'];

        if ((userNameOrEmail == decryptedUsername ||
            userNameOrEmail == decryptedEmail) &&
            password == decryptedPassword) {
          await prefs.setBool('isLoggedIn', true); // Menandai login
          setState(() {
            _errorText = '';
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/');
          });
        } else {
          setState(() {
            _errorText = "Username/Email atau Password salah.";
          });
        }
      } else {
        setState(() {
          _errorText = "Data pengguna tidak ditemukan. Silakan daftar terlebih dahulu.";
        });
      }
    } catch (e) {
      setState(() {
        _errorText = "Terjadi kesalahan saat login. Coba lagi.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("Images/welcome.png"),
              const SizedBox(height: 16),
              const Text(
                "Login Detail",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: "Username atau Email",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  hintText: "Password",
                ),
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 16),
              if (_errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorText,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _signin,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: "Belum Punya Akun? ",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                  children: [
                    TextSpan(
                      text: "Daftar di sini",
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/signup');
                        },
                    ),
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