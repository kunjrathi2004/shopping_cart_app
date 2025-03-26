import 'package:flutter_bloc/flutter_bloc.dart';

class CartEvent {
  final Product product;
  final int quantity;

  CartEvent(this.product, this.quantity);
}

class CartState {
  final Map<Product, int> items;

  CartState(this.items);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState({}));

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    final currentItems = Map<Product, int>.from(state.items);
    if (currentItems.containsKey(event.product)) {
      currentItems[event.product] = currentItems[event.product]! + event.quantity;
    } else {
      currentItems[event.product] = event.quantity;
    }
    yield CartState(currentItems);
  }
}
