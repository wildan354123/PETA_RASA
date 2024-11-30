import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PETA_RASA/screens/home_screen.dart';
import 'package:PETA_RASA/screens/profile_screen.dart';
import 'package:PETA_RASA/screens/search_screen.dart';
import 'package:PETA_RASA/screens/sign_in.dart';
import 'package:PETA_RASA/screens/sign_up.dart';
import 'package:PETA_RASA/screens/favorite_screen.dart';
import 'package:PETA_RASA/provider/favorites_provider.dart';
import 'package:PETA_RASA/provider/signin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memeriksa status login dari SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

  runApp(MyApp(isSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  const MyApp(this.isSignedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final provider = SignInProvider();
          provider.setLoginStatus(isSignedIn); // Set initial login status
          return provider;
        }),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'PETA RASA',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.deepPurple),
            titleTextStyle: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .copyWith(primary: Colors.deepPurple, surface: Colors.deepPurple[50]),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/homescreen': (context) => const HomeScreen(),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/favorite': (context) => const FavoriteScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar layar yang akan ditampilkan sesuai dengan indeks
  final List<Widget> _children = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // Menampilkan layar yang dipilih
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple[50]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.deepPurple),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.deepPurple),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.deepPurple),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple[100],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
