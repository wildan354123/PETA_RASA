import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:PETA_RASA/screens/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _TampilanProfileState();
}

class _TampilanProfileState extends State<ProfileScreen> {
  String _imageFile = '';
  final picker = ImagePicker();

  bool isLoggedIn = false;
  List<String> history = [];
  String _NamaLengkap = '';
  String _UserName = '';
  String _Email = '';

  TextEditingController bioController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    if (kIsWeb && source == ImageSource.camera) {
      debugPrint('Kamera tidak didukung di Web. Gunakan perangkat fisik.');
      return;
    }

    try {
      final pickedFile = await picker.pickImage(
          source: source,
          maxHeight: 720,
          maxWidth: 720,
          imageQuality: 80
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile.path;
          debugPrint('File path: $_imageFile');
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.lightGreen[50],
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera, color: Colors.lightGreen),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                      Icons.photo_library, color: Colors.lightGreen),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Navigator.pushReplacementNamed(context, '/signin');
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedNamaLengkap = prefs.getString('NamaLengkap') ?? '';
    final encryptedUsername = prefs.getString('UserName') ?? '';
    final encryptedEmail = prefs.getString('Email') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';
    final savedBio = prefs.getString('Bio') ?? '';

    if (encryptedNamaLengkap.isNotEmpty && encryptedUsername.isNotEmpty &&
        encryptedEmail.isNotEmpty && keyString.isNotEmpty &&
        ivString.isNotEmpty) {
      try {
        final key = encrypt.Key.fromBase64(keyString);
        final iv = encrypt.IV.fromBase64(ivString);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        setState(() {
          _NamaLengkap = encrypter.decrypt64(encryptedNamaLengkap, iv: iv);
          _UserName = encrypter.decrypt64(encryptedUsername, iv: iv);
          _Email = encrypter.decrypt64(encryptedEmail, iv: iv);
          bioController.text = savedBio;
          isLoggedIn = true;
        });
      } catch (e) {
        setState(() {
          _NamaLengkap = 'Dekripsi gagal';
          _UserName = 'Dekripsi gagal';
          _Email = 'Dekripsi gagal';
          isLoggedIn = false;
        });
      }
    } else {
      setState(() {
        _NamaLengkap = 'Data tidak tersedia';
        _UserName = 'Data tidak tersedia';
        _Email = 'Data tidak tersedia';
        isLoggedIn = false;
      });
    }
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }


  Future<void> _login() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  Future<void> _saveBio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Bio', bioController.text);
    setState(() {
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bio berhasil disimpan.')),
    );
  }


  @override
  void initState() {
    super.initState();
    getUserData();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.lightGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.lightGreen, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile.isNotEmpty
                            ? (kIsWeb
                            ? NetworkImage(_imageFile)
                            : FileImage(File(_imageFile))) as ImageProvider
                            : const AssetImage('Images/user.png'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: _showPicker,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              // User Info
              Text(
                _UserName,
                style: const TextStyle(fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen),
              ),
              const SizedBox(height: 8),
              Text(
                _Email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                _NamaLengkap,
                style: const TextStyle(fontSize: 18, color: Colors.lightGreen),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bioController,
                maxLines: 3,
                textAlign: TextAlign.center,  // Center the text inside the TextField
                style: const TextStyle(color: Colors.grey),  // Set the input text color to grey
                decoration: InputDecoration(
                  hintText: 'Tulis bio Anda di sini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white), // Focused border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white), // Enabled border color
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust horizontal padding
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveBio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'Simpan Bio',
                  style: TextStyle(color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
        
              // Login / Logout Button
              ElevatedButton(
                onPressed: isLoggedIn ? _logout : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  isLoggedIn ? 'Logout' : 'Login',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
