import 'package:flutter/material.dart';
import 'package:PETA_RASA/models/makanan.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Makanan> _favorites = []; // List hanya berisi objek Candi

  // Getter untuk mengakses daftar favorit
  List<Makanan> get favorites => _favorites;

  // Menambahkan candi ke daftar favorit
  void addFavorite(Makanan makanan) {
    _favorites.add(makanan);
    notifyListeners(); // Memberitahu widget yang mendengarkan perubahan
  }

  // Menghapus candi dari daftar favorit
  void removeFavorite(Makanan makanan) {
    _favorites.remove(makanan);
    notifyListeners(); // Memberitahu widget bahwa ada perubahan
  }

  // Mengecek apakah candi sudah ada di daftar favorit
  bool isFavorite(Makanan makanan) {
    return _favorites.contains(makanan);
  }
}
