import 'package:PETA_RASA/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PETA_RASA/screens/sign_up.dart';
import 'package:PETA_RASA/screens/favorite_screen.dart';
import 'package:PETA_RASA/provider/favorites_provider.dart';
import 'package:PETA_RASA/provider/signin_provider.dart';
import 'package:PETA_RASA/widgets/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mendapatkan instance SharedPreferences dan memuat status login
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

  // Membuat SignInProvider dan memuat status login
  final signInProvider = SignInProvider();
  await signInProvider.loadLoginStatus();  // Memuat status login dari SharedPreferences

  runApp(MyApp(signInProvider, isSignedIn));
}

class MyApp extends StatelessWidget {
  final SignInProvider signInProvider;
  final bool isSignedIn;

  const MyApp(this.signInProvider, this.isSignedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => signInProvider),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'PETA RASA',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreen,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen).copyWith(
            primary: Colors.lightGreen,
            secondary: Colors.lightGreen,
            surface: Colors.white,
            onSurface: Colors.lightGreen,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/favorite': (context) => const FavoriteScreen(),
        },
      ),
    );
  }
}
