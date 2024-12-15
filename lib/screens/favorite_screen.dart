import 'package:PETA_RASA/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:PETA_RASA/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan provider untuk favorites
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    // Tampilan daftar favorit
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Belum ada makanan favorit!'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final makanan = favorites[index];
          return InkWell(
            onTap: () {
              // Navigasi ke DetailScreen ketika item ditekan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(makanan: makanan),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar makanan dengan ukuran tetap
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        makanan.imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Column untuk teks nama dan lokasi makanan
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            makanan.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            makanan.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer untuk mendorong ikon ke kanan
                  const Spacer(),
                  // Tombol untuk menghapus makanan favorit
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      favoritesProvider.removeFavorite(makanan);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
