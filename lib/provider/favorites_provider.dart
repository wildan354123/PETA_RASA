import 'package:flutter/material.dart';
import 'package:PETA_RASA/models/makanan.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Makanan> _favorites = [];

  List<Makanan> get favorites => _favorites;

  void addFavorite(Makanan makanan) {
    _favorites.add(makanan);
    notifyListeners(); // Memberitahu widget yang mendengarkan perubahan
  }

  void removeFavorite(Makanan makanan) {
    _favorites.remove(makanan);
    notifyListeners();
  }

  bool isFavorite(Makanan makanan) {
    return _favorites.contains(makanan);
  }
}
