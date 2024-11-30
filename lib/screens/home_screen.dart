import 'package:flutter/material.dart';
import 'package:PETA_RASA/data/makanan_data.dart';
import 'package:PETA_RASA/models/makanan.dart';
import 'package:PETA_RASA/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO : 1. Buat appbar dengan judul Peta Rasa
      appBar: AppBar(title: Text('PETA RASA'),),
      // TODO : 2. Buat body dengan GridView.Builder
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.all(8),
        itemCount: makananList.length,
        itemBuilder: (context, index) {
          final Makanan makanan = makananList[index];
          return ItemCard(makanan: makanan);
        },
        // TODO : 3. Buat ItemCard sebagai return value dari GridView.Builder
      ),
    );
  }
}
