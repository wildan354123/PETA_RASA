import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:PETA_RASA/models/makanan.dart';
import 'package:PETA_RASA/provider/favorites_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Makanan makanan;
  const DetailScreen({super.key, required this.makanan});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _userRating = 0.0;
  TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? commentsJson = prefs.getString('comments_${widget.makanan.name}');
    if (commentsJson != null) {
      List<dynamic> decodedComments = json.decode(commentsJson);
      setState(() {
        _comments =
            decodedComments.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> _saveComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String commentsJson = json.encode(_comments);
    await prefs.setString('comments_${widget.makanan.name}', commentsJson);
  }

  void _addComment(double rating, String comment) {
    setState(() {
      _comments.add({
        'rating': rating,
        'comment': comment,
      });
    });
    _saveComments();
    _userRating = 0.0;
    _commentController.clear();
  }

  void _updateComment(int index, double rating, String comment) {
    setState(() {
      _comments[index] = {
        'rating': rating,
        'comment': comment,
      };
    });
    _saveComments();
    _editingIndex = null;
    _commentController.clear();
  }

  void _deleteComment(int index) {
    setState(() {
      _comments.removeAt(index);
    });
    _saveComments();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bool isFavorite = favoritesProvider.isFavorite(widget.makanan);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header detail
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.makanan.imageAsset,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),
            // Info makanan

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favoritesProvider.removeFavorite(widget.makanan);
                            } else {
                              favoritesProvider.addFavorite(widget.makanan);
                            }
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.makanan.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.red),
                      const SizedBox(width: 9),
                      const SizedBox(
                        width: 70,
                        child: Text(
                          'Lokasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Text(
                        ': ${widget.makanan.location}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.yellow),
                      const SizedBox(width: 9),
                      const SizedBox(
                        width: 70,
                        child: Text(
                          'Kategori',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Text(
                        ': ${widget.makanan.category}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Divider(color: Colors.deepPurple.shade100),
                  const SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.makanan.description}',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Beri ulasan anda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                    },
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Tambah ulasan',
                      hintText: 'Tulis ulasanmu disini...',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_userRating > 0 &&
                          _commentController.text.isNotEmpty) {
                        if (_editingIndex != null) {
                          _updateComment(_editingIndex!, _userRating,
                              _commentController.text);
                        } else {
                          _addComment(_userRating, _commentController.text);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please enter a rating and comment')),
                        );
                      }
                    },
                    child: Text(_editingIndex != null
                        ? 'Ubah ulasan  '
                        : 'Tambah ulasan '),
                  ),
                ],
              ),
            ),
            // Menampilkan komentar dan rating
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ulasan:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _comments.isEmpty
                      ? Text('No comments yet')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: RatingBar.builder(
                                  initialRating: _comments[index]['rating'],
                                  minRating: 1,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    _updateComment(index, rating,
                                        _comments[index]['comment']);
                                  },
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_comments[index]['comment']),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              _editingIndex = index;
                                              _commentController.text =
                                                  _comments[index]['comment'];
                                              _userRating =
                                                  _comments[index]['rating'];
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _deleteComment(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
