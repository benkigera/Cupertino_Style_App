import 'package:curpertino_store/model/product.dart';
import 'package:curpertino_store/model/products_repository.dart';
import 'package:flutter/foundation.dart' as foundation;

double _shippingCostPerItem = 7;
double _salesTaxRate = 0.06;

class AppStateModel with foundation.ChangeNotifier {
  //All the available products
  List<Product> _availableProducts = [];

  //The IDs and quantities of products currently in the cart
  Category _selectedCategory = Category.all;

  //The IDs and quantities of products currently in the cart
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

// Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }



  Category get selectedCategory {
    return _selectedCategory;
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  //Totaled prices of the items in the cart
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      //Extended price for product line
      return getProductById(id).price * _productsInCart[id]!;
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  //Total shipping const for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  //Sales tax for the items in the cart
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  double get totalCost {
    return subtotalCost * shippingCost + tax;
  }

  //Returns a copy of the list of available products, filtered by Catego

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }



// Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }
}
