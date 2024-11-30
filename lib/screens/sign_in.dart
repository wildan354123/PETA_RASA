import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO:1. Deklarasikan variabel
  final TextEditingController _usernamecontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  String _errorText = '';

  bool _isSignedIn = false;

  bool _obscurePassword = true;

  void _signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedUsername = prefs.getString('username') ?? '';
    final String savedPassword = prefs.getString('password') ?? '';
    final String enteredUsername = _usernamecontroller.text.trim();
    final String enteredPassword = _passwordcontroller.text.trim();

    if (enteredUsername == savedUsername && enteredPassword == savedPassword){
      setState(() {
        _errorText = "";
        _isSignedIn = true;
        prefs.setBool('isSignedIn', true);
      });
      //   pemanggilan untuk menghapus semua halaman dalam tumpulkan navigasi
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).popUntil((route)=>route.isFirst);
      });
      //   sign in berhasil, navigasi ke layar utama
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacementNamed(context, '/');
      });

    }
    if(savedUsername.isEmpty || savedPassword.isEmpty){
      setState(() {
        _errorText = 'Pengguna belum terdaftar. silakan daftar terlebih dahulu';
      });
    }

    else {
      setState(() {
        _errorText = 'Nama pengguna atau kata sandi salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   TODO: 2. pasang appbar
      appBar: AppBar(title: Text('Sign In'),),
      //   TODO: 3. Pasang body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                child: Column(
                  // TODO:4 ATUR MAINXISALIGNMENT DAN CROSSASISALIGNMENT
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //   Todo:5. pasang textformfield nama pengguna
                    TextFormField(
                      controller: _usernamecontroller,
                      decoration: InputDecoration(
                        labelText: "Nama pengguna",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //   TODO 6. Pasang textform kata sandi
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        labelText: "kata sandi",
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off
                                :Icons.visibility,
                          ),),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    //   Todo 7. pasang elevated sign in
                    SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: (){
                          _signIn();
                        },
                        child: Text("Sign In")),
                    //   TODO 8. PASANG TEXT BUTTON SIGN UP
                    SizedBox(height: 10,),
                    // TextButton(
                    //     onPressed: (){},
                    //     child: Text("Belum punya akun? daftar di sini")),
                    RichText(
                        text: TextSpan(
                          text: "Belum Punya Akun?",
                          style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Daftar disini",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  Navigator.pushNamed(context, '/signup');
                                },
                            ),
                          ],
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}