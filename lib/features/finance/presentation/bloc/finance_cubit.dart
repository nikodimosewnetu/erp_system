import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/finance.dart';
import '../../domain/repositories/finance_repository_interface.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final FinanceRepositoryInterface repository;
  FinanceCubit(this.repository) : super(FinanceInitial());

  Future<void> fetchFinances() async {
    emit(FinanceLoading());
    try {
      final finances = await repository.getFinances();
      emit(FinanceLoaded(finances));
    } catch (e) {
      emit(FinanceError('Failed to fetch finances'));
    }
  }

  Future<void> createFinance(Map<String, dynamic> data) async {
    emit(FinanceLoading());
    try {
      await repository.createFinance(data);
      await fetchFinances();
    } catch (e) {
      emit(FinanceError('Failed to create finance record'));
    }
  }

  Future<void> updateFinance(int id, Map<String, dynamic> data) async {
    emit(FinanceLoading());
    try {
      await repository.updateFinance(id, data);
      await fetchFinances();
    } catch (e) {
      emit(FinanceError('Failed to update finance record'));
    }
  }

  Future<void> deleteFinance(int id) async {
    emit(FinanceLoading());
    try {
      await repository.deleteFinance(id);
      await fetchFinances();
    } catch (e) {
      emit(FinanceError('Failed to delete finance record'));
    }
  }
}
