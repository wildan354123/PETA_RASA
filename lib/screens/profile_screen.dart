import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = false;
  String fullName = "Guest";
  String userName = "guest_user";
  int favoriteMakananCount = 0;

  // Implementasi Fungsi Sign In
  void signIn() {
    setState(() {
      isSignedIn = true;
    //   userName = 'budi';
    //   fullName = 'Budi Santoso';
    //   favoriteMakananCount = 3;

      //   userName = 'budi';
      //   fullName = 'Budi Santoso';
      //   favoriteCandiCount = 3;
    });
  }

  // Implementasi Fungsi Sign Out
  void signOut() {
    setState(() {
      isSignedIn = false;
    //   userName = 'guest_user';
    //   fullName = 'Guest';
    //   favoriteMakananCount = 0;
      //   userName = 'guest_user';
      //   fullName = 'Guest';
      //   favoriteCandiCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background header
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepOrange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Profile header
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
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
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.deepOrange,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Profile info
                const SizedBox(height: 20),
                Divider(color: Colors.deepOrange[100]),
                _buildProfileInfo(
                  context,
                  icon: Icons.lock,
                  label: "Pengguna",
                  value: userName,
                  iconColor: Colors.amber,
                ),
                Divider(color: Colors.deepOrange[100]),
                _buildProfileInfo(
                  context,
                  icon: Icons.person,
                  label: "Nama",
                  value: fullName,
                  iconColor: Colors.blue,
                ),
                Divider(color: Colors.deepOrange[100]),
                _buildProfileInfo(
                  context,
                  icon: Icons.favorite,
                  label: "Favorite",
                  value: "$favoriteMakananCount",
                  iconColor: Colors.red,
                ),
                Divider(color: Colors.deepOrange[100]),
                const SizedBox(height: 20),
                // Profile action (Sign In/Out)
                TextButton(
                  onPressed: isSignedIn ? signOut : signIn,
                  style: TextButton.styleFrom(
                    backgroundColor: isSignedIn ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isSignedIn ? "Sign Out" : "Sign In"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi profil
  Widget _buildProfileInfo(BuildContext context,
      {required IconData icon,
        required String label,
        required String value,
        required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              ': $value',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
