class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final Map rating;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "rating": rating,
      "category": category,
      "image": image
    };
  }
}