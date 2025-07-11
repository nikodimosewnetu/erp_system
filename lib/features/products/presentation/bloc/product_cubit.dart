import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;
  ProductCubit(this.productRepository) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await productRepository.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to fetch products'));
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    emit(ProductLoading());
    try {
      await productRepository.createProduct(data);
      await fetchProducts();
    } catch (e) {
      emit(ProductError('Failed to create product'));
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    emit(ProductLoading());
    try {
      await productRepository.updateProduct(id, data);
      await fetchProducts();
    } catch (e) {
      emit(ProductError('Failed to update product'));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      await productRepository.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      emit(ProductError('Failed to delete product'));
    }
  }
}
