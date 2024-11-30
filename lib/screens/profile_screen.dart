import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk membaca status login dari SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      userName = prefs.getString('Username') ?? '';
      fullName = prefs.getString('FullName') ?? '';
      favoriteCandiCount = prefs.getInt('FavoriteCandiCount') ?? 0;
    });
  }

  // Fungsi untuk menangani Sign In
  void signIn() {
    Navigator.pushNamed(context, '/signin').then((_) {
      _loadUserData();  // Memuat data setelah kembali dari halaman Sign In
    });
  }

  // Fungsi untuk menangani Sign Out
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn = false;
      prefs.setBool('isSignedIn', false);  // Set status login ke false
      prefs.remove('Username');  // Hapus data pengguna
      prefs.remove('FullName');
      prefs.remove('FavoriteCandiCount');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepOrange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Bagian ProfileHeader dengan gambar profil
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/place_holder.jpeg'),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.camera_alt, color: Colors.deepOrange[50])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepOrange[100]),
                const SizedBox(height: 4),
                // Info Profil Pengguna
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: const Row(
                        children: [
                          Icon(Icons.lock, color: Colors.amber),
                          SizedBox(width: 8),
                          Text('Pengguna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(': $userName', style: const TextStyle(fontSize: 18)),
                    ),
                    if (isSignedIn) const Icon(Icons.edit),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepOrange[100]),
                const SizedBox(height: 4),
                // Info Nama Pengguna
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: const Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Nama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(': $fullName', style: const TextStyle(fontSize: 18)),
                    ),
                    if (isSignedIn) const Icon(Icons.edit),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepOrange[100]),
                const SizedBox(height: 4),
                // Info Favorit
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: const Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Favorit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(': $favoriteCandiCount', style: const TextStyle(fontSize: 18)),
                    ),
                    if (isSignedIn) const Icon(Icons.edit),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepOrange[100]),
                const SizedBox(height: 20),
                // Tombol Sign In/Sign Out
                isSignedIn
                    ? TextButton(onPressed: signOut, child: const Text('Sign Out'))
                    : TextButton(onPressed: signIn, child: const Text('Sign In')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
