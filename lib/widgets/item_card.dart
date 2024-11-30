import 'package:flutter/material.dart';
import 'package:PETA_RASA/screens/detail_screen.dart';
import '../models/makanan.dart';

class ItemCard extends StatelessWidget {
  //TODO: 1. Deklarasikan variabel yang dibutuhkan dan pasang pada konstruktor
  final Makanan makanan ;
  const ItemCard({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    // TODO: 6. Implementasi routing ke DetailScreen
    return InkWell(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => DetailScreen(makanan: makanan),
          ),
        );
      },
      child: Card(
        //TODO: 2. Tetapkan parameter shape, margin, dan elevation dari Card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        margin: const EdgeInsets.all(4),
        elevation: 1,
        child: Column(
          children: [
            //TODO: 3. Buat Image sebagai anak dari Column
            Expanded(
              //TODO: 7. Implementasi Hero animation
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15) ,
                child: Image.asset(
                    makanan.imageAsset,
                    width: double.infinity,
                    fit: BoxFit.cover
                ),
              ),
            ),
            //TODO: 4. Buat Text sebagai anak dari Column
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                makanan.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //TODO: 5. Buat Text sebagai anak dari Column
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                  makanan.resep,
                  style: const TextStyle(fontSize: 12)
              ),
            ),
          ],
        ),
      ),
    );
  }
}