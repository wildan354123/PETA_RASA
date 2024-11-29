import 'package:flutter/material.dart';
import 'package:wisata_candi/models/makanan.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Candi> _favorites = []; // List hanya berisi objek Candi

  // Getter untuk mengakses daftar favorit
  List<Candi> get favorites => _favorites;

  // Menambahkan candi ke daftar favorit
  void addFavorite(Candi candi) {
    _favorites.add(candi);
    notifyListeners(); // Memberitahu widget yang mendengarkan perubahan
  }

  // Menghapus candi dari daftar favorit
  void removeFavorite(Candi candi) {
    _favorites.remove(candi);
    notifyListeners(); // Memberitahu widget bahwa ada perubahan
  }

  // Mengecek apakah candi sudah ada di daftar favorit
  bool isFavorite(Candi candi) {
    return _favorites.contains(candi);
  }
}
