class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],  // Use 'title' instead of 'name'
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']?['rate'] ?? 0).toDouble(),
    );
  }
}
