import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Todo 1 Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = true;
  String fullName = "";
  String userName = "";
  int favoriteCandiCount = 0;
  late Color iconColor;

  // Todo 5 Implementasi Fungsi Sign In
  void signIn(){
    // setState(() {
    //   isSignedIn = 'true';
    //   userName = 'budi';
    //   fullName = 'Budi Santoso';
    //   favoriteCandiCount = 3;
    // });
    Navigator.pushNamed(context, '/signin');
  }
  // Todo 6 Implementasi Fungsi Sign Out
  void signOut(){
    setState(() {
      isSignedIn = !isSignedIn;
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
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                //   TODO 2 Buat bagian Profile header yang berisi gambar profile
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200-50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple, width: 2),
                              shape: BoxShape.circle
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/placeholder_image.png'),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.camera_alt, color: Colors.deepPurple[50],),),
                      ],
                    ),
                  ),
                ),
                //   TODO 3. buat bagian profile info yang berisi info profile
                SizedBox(height: 20,),
                Divider(color: Colors.deepPurple[100]),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.amber,),
                          SizedBox(width: 8,),
                          Text('Pengguna', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),),
                    Expanded(
                      child: Text(': $userName' , style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          SizedBox(width: 8,),
                          Text('Nama' , style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),)
                        ],
                      ),),
                    Expanded(
                      child: Text(': $fullName', style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8,),
                          Text('Favorite' , style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),)
                        ],
                      ),),
                    Expanded(
                      child: Text(': $favoriteCandiCount', style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                //   TODO 4 buat profileAction yang berisi text Button sign in /out
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 20,),
                isSignedIn ? TextButton(onPressed: signOut, child: Text('Sign Out'))
                    :TextButton(onPressed: signIn, child: Text('Sign In'))
              ],
            ),
          )
        ],
      ),
    );
  }
}