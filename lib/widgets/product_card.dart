import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = product.rating.floor();
    bool hasHalfStar = (product.rating - fullStars) >= 0.5;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // Favourite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onToggleFavourite,
                  ),
                ),
              ],
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text('৳${product.price}', style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    for (int i = 0; i < fullStars; i++)
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                    if (hasHalfStar)
                      const Icon(Icons.star_half, color: Colors.orange, size: 16),
                    for (int i = 0; i < 5 - fullStars - (hasHalfStar ? 1 : 0); i++)
                      const Icon(Icons.star_border, color: Colors.orange, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
