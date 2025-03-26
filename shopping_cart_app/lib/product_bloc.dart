import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_repository.dart';

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

  ProductBloc(this.productRepository) : super(ProductLoading());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadProducts) {
      yield ProductLoading();
      try {
        final products = await productRepository.fetchProducts(event.page);
        yield ProductLoaded(products);
      } catch (_) {
        yield ProductState(); // Handle error state
      }
    }
  }
}
