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

  // Track the login state
  bool isLoggedIn = false;

  List<String> history = [];

  String _NamaLengkap = '';
  String _UserName = '';
  String _Email = '';

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
      debugPrint('Error picking imageL $e');
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
                  leading: const Icon(
                      Icons.camera,
                      color: Colors.lightGreen
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    debugPrint('Kamera dipanggil');
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                      Icons.photo_library,
                      color: Colors.lightGreen
                  ),
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
    await prefs.remove('isLoggedIn'); // Hanya menghapus status login
    Navigator.pushReplacementNamed(context, '/signin');
  }


  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedNamaLengkap = prefs.getString('NamaLengkap') ?? '';
    final encryptedUsername = prefs.getString('UserName') ?? '';
    final encryptedEmail = prefs.getString('Email') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (encryptedNamaLengkap.isNotEmpty &&
        encryptedUsername.isNotEmpty &&
        encryptedEmail.isNotEmpty &&
        keyString.isNotEmpty &&
        ivString.isNotEmpty) {
      try {
        final key = encrypt.Key.fromBase64(keyString);
        final iv = encrypt.IV.fromBase64(ivString);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        setState(() {
          _NamaLengkap = encrypter.decrypt64(encryptedNamaLengkap, iv: iv);
          _UserName = encrypter.decrypt64(encryptedUsername, iv: iv);
          _Email = encrypter.decrypt64(encryptedEmail, iv: iv);
          isLoggedIn = true; // Mark as logged in
        });
      } catch (e) {
        setState(() {
          _NamaLengkap = 'Dekripsi gagal';
          _UserName = 'Dekripsi gagal';
          _Email = 'Dekripsi gagal';
          isLoggedIn = false; // If decryption fails, treat as logged out
        });
      }
    } else {
      setState(() {
        _NamaLengkap = 'Data tidak tersedia';
        _UserName = 'Data tidak tersedia';
        _Email = 'Data tidak tersedia';
        isLoggedIn = false; // No data available, treat as logged out
      });
    }
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen[50],
          title: const Text('Riwayat',
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Berikut adalah kuliner yang telah Anda ulas:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          '${index + 1}.  ${history[index]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightGreen, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile.isNotEmpty
                          ? (kIsWeb
                          ? NetworkImage(_imageFile)
                          : FileImage(File(_imageFile))) as ImageProvider
                          : const AssetImage('Images/user.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: _showPicker,
                    icon: const Icon(Icons.camera_alt),
                    color: Colors.lightGreen,
                    iconSize: 30,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _UserName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _Email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.lightGreen,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _NamaLengkap,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Conditional button rendering based on login state
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoggedIn ? _logout : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLoggedIn ? 'Logout' : 'Login',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: IconButton(
                onPressed: _showHistoryDialog,
                icon: const Icon(Icons.history),
                color: Colors.white,
                iconSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
