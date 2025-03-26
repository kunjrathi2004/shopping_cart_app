import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_bloc.dart';

class ProductEventHandler {
  static void registerHandlers(ProductBloc productBloc) {
    productBloc.on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productBloc.productRepository.fetchProducts(event.page);
        emit(ProductLoaded(products));
      } catch (_) {
        emit(ProductState()); // Handle error state
      }
    });
  }
}
