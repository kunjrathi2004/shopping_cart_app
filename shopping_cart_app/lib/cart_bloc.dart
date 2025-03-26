import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_repository.dart';

class LoadProductsEvent {}

class CartEvent {
  final Product product;
  final int quantity;

  CartEvent(this.product, this.quantity);
}

class CartState {
  final Map<Product, int> items;

  CartState(this.items);
}

class CartBloc extends Bloc<dynamic, CartState> {
  CartBloc() : super(CartState({}));

  @override
  Stream<CartState> mapEventToState(dynamic event) async* {
    if (event is LoadProductsEvent) {
      final products = await ProductRepository().fetchProducts(1); // Fetching first page
      yield CartState(Map.fromIterable(products, key: (product) => product, value: (product) => 0)); // Update with fetched products
    } else if (event is CartEvent) {
      final currentItems = Map<Product, int>.from(state.items);
      if (currentItems.containsKey(event.product)) {
        currentItems[event.product] = currentItems[event.product]! + event.quantity;
      } else {
        currentItems[event.product] = event.quantity;
      }
      yield CartState(currentItems);
    }
  }
}
