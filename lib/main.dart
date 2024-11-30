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
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'PETA RASA',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange).copyWith(
            primary: Colors.deepOrange,
            secondary: Colors.deepOrangeAccent,
            surface: Colors.deepOrange[50],
            onSurface: Colors.deepOrange[800],
          ),
          scaffoldBackgroundColor: Colors.deepOrange[50],
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
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
  final PageController _pageController = PageController();

  final List<Widget> _children = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _children,
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.search, 1),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.favorite, 2),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, 3),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 6,
          )
        ]
            : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.deepOrange : Colors.white70,
        size: 24,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
