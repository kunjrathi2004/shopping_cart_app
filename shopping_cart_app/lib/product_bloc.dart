import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_repository.dart';
import 'product_event_handler.dart';

class ProductEvent {
  final int page;

  ProductEvent(this.page);
}

class LoadProducts extends ProductEvent {
  LoadProducts(int page) : super(page);
}

class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductLoading()) {
    ProductEventHandler.registerHandlers(this);
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    // The event handling is now managed in the ProductEventHandler
  }
}
