class Makanan{
  final String name;
  final String location;
  final String category;
  final String description;
  final String imageAsset;
  final List<String> imageAsset2;
  bool isFavorite;
  double rating;

  Makanan({
    required this.name,
    required this.location,
    required this.category,
    required this.description,
    required this.imageAsset,
    required this.imageAsset2,
    this.isFavorite = false,
    this.rating = 0.0,

});

}
