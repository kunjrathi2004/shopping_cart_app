import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_bloc.dart';
import 'product_repository.dart';
import 'cart_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductBloc(ProductRepository())),
          BlocProvider(create: (context) => CartBloc()),
        ],
        child: ProductListScreen(),
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(LoadProducts(currentPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  currentPage++;
                  BlocProvider.of<ProductBloc>(context).add(LoadProducts(currentPage));
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context).add(CartEvent(product, 1));
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('Failed to load products'));
          }
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(child: Text('No items in the cart'));
          }
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final product = state.items.keys.elementAt(index);
              final quantity = state.items[product]!;
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Quantity: $quantity'),
                trailing: Text('\$${product.price * quantity}'),
              );
            },
          );
        },
      ),
    );
  }
}
