import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/product_card.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortOption = 'None';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildIconButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 20,
            child: icon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    List<Product> filteredProducts = _searchQuery.isEmpty
        ? productProvider.products
        : productProvider.products.where((product) {
            return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    
    if (_sortOption == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortOption == 'Rating: High to Low') {
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Shop"),
        centerTitle: true,
        actions: [
          _buildIconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            tooltip: 'Favourites',
            onPressed: () {
              Navigator.pushNamed(context, '/favourites');
            },
          ),
          _buildIconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart, color: Colors.black87),
                if (cartProvider.items.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartProvider.items.length.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          _buildIconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.black87,
            ),
            tooltip: themeProvider.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          _buildIconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            tooltip: "Logout",
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(width: 6), 
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Sort dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sort by:"),
                  DropdownButton<String>(
                    value: _sortOption,
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('None')),
                      DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                      DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                      DropdownMenuItem(value: 'Rating: High to Low', child: Text('Rating: High to Low')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Product grid
              Expanded(
                child: productProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredProducts.isEmpty
                        ? const Center(child: Text("No products found."))
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final isFav = favouritesProvider.isFavourite(product.id);

                              return ProductCard(
                                product: product,
                                onAddToCart: () {
                                  cartProvider.addProduct(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${product.name} added to cart!')),
                                  );
                                },
                                isFavourite: isFav,
                                onToggleFavourite: () {
                                  favouritesProvider.toggleFavourite(product.id);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
